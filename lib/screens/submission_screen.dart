import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:homework_app/models/grade.dart';
import 'package:homework_app/models/homework.dart';
import 'package:homework_app/models/student.dart';
import 'package:homework_app/models/subjects.dart';
import 'package:homework_app/models/submission.dart';
import 'package:homework_app/utils.dart';
import 'package:intl/intl.dart';

/// A screen that allows the user to submit a homework.
/// Has to be a stateful widget because of the file picker
/// and the ability to add a note.
class SubmissionScreen extends StatefulWidget {
  static const routeName = '/submission_screen';

  const SubmissionScreen({Key? key}) : super(key: key);

  @override
  State<SubmissionScreen> createState() => _SubmissionScreenState();
}

class _SubmissionScreenState extends State<SubmissionScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _selectedFile;
  String _fileName = '';
  String _note = '';
  bool _isLoading = false;

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result == null) {
      setState(() => _selectedFile = null);
      return;
    }

    setState(() {
      _selectedFile = File(result.files.single.path!);
    });
    _fileName = (result.files.single.path)!.split('/').last;
  }

  /// Attempts to submit the form and save the data to the database, if the form is valid.
  Future<void> _submitForm(
      Homework homework, Submission? submission, Student user) async {
    _formKey.currentState!.save();

    setState(() => _isLoading = true);

    try {
      String url = '';
      if (_selectedFile != null &&
          Utils.isFileTooBig(_selectedFile!.lengthSync())) {
        if (submission != null && submission.attachmentUrl != '') {
          FirebaseStorage.instance
              .refFromURL(submission.attachmentUrl)
              .delete();
        }

        final ref = FirebaseStorage.instance
            .ref()
            .child('submissions')
            .child(homework.id)
            .child(user.uco)
            .child(_fileName);

        await ref.putFile(_selectedFile!);
        url = await ref.getDownloadURL();
      }

      Map<String, dynamic> fields = {
        'homeworkId': homework.id,
        'note': _note,
        'attachmentUrl': url,
        'submittedAt': DateTime.now(),
        'studentUCO': user.uco,
        'studentName': user.name,
        'studentSurname': user.surname,
        'teacherUCO': homework.teacherUCO,
        'grade': submission == null
            ? Grade.none.toEnglishString()
            : submission.grade,
      };

      if (submission == null) {
        await FirebaseFirestore.instance.collection('submissions').add(fields);
      } else {
        await FirebaseFirestore.instance
            .collection('submissions')
            .doc(submission.id)
            .update(
          {
            'note': _note,
            'attachmentUrl': url,
            'submittedAt': DateTime.now(),
          },
        );
      }
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message!),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    setState(() => _isLoading = false);
  }

  /// Builds the screen and draws it.
  @override
  Widget build(BuildContext context) {
    /// Gets the arguments passed to the screen,
    /// such as the homework this submission is for,
    /// the submission itself if it already exists in order to be edited,
    /// the user who is creating/editing this submission
    /// and a function to refresh the homework list upon completion.
    final options = ModalRoute.of(context)!.settings.arguments as List;
    final Homework homework = options[0];
    final Submission? submission = options[1];
    final Student user = options[2];
    final void Function() refreshHandler = options[3];

    return Scaffold(
      appBar: AppBar(
        title: Text(homework.title),
        actions: [
          /// Button which takes care of document upload.
          IconButton(
            onPressed: _pickFile,
            icon: Visibility(
              replacement: const Icon(Icons.file_download_done),
              visible: homework.attachmentUrl == '',
              child: const Icon(Icons.attach_file),
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    homework.subject.toEnglishString(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  alignment: Alignment.topLeft,
                  width: 500,
                  height: 150,
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: 300,
                      child: Text(
                        homework.description,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                /// If the homework has an attachment,
                /// a button to download it is displayed,
                /// otherwise it is disabled.
                Container(
                  alignment: Alignment.centerRight,
                  child: FilledButton.tonalIcon(
                    onPressed: homework.attachmentUrl == ''
                        ? null
                        : () =>
                            Utils.downloadFile(homework.attachmentUrl, context),
                    icon: const Icon(Icons.file_download_outlined),
                    label: const Text('Stiahnuť zadanie'),
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(),
                Text(DateFormat('dd.M.yyyy').format(homework.deadline),
                    style: Theme.of(context).textTheme.headlineSmall),
                const Divider(),
                const SizedBox(height: 20),

                /// If the submission already exists,
                /// the form is pre-filled with its data.
                /// Takes a note from the user.
                Form(
                  key: _formKey,
                  child: Container(
                    height: 200,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.surfaceVariant,
                    ),
                    child: TextFormField(
                      initialValue: submission?.note,
                      onSaved: (newValue) => _note = newValue!.trim(),
                      maxLines: 5,
                      textCapitalization: TextCapitalization.sentences,
                      autocorrect: true,
                      decoration: const InputDecoration(
                        hintText: 'Poznámka',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),

      /// Button to submit the form and create/edit the submission.
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Visibility(
          replacement: const CircularProgressIndicator(),
          visible: !_isLoading,
          child: FloatingActionButton.extended(
            onPressed: () async {
              await _submitForm(homework, submission, user);
              refreshHandler();
              Navigator.of(context).pop();
            },
            label: const Text('Odovzdať'),
            icon: const Icon(Icons.check),
          ),
        ),
      ),
    );
  }
}
