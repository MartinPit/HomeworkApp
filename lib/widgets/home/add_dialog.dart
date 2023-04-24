import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:homework_app/widgets/home/dropdown_chip.dart';

import '../../models/classes.dart';
import '../../models/subjects.dart';
import '../../models/teacher.dart';
import '../../utils.dart';

class AddDialog extends StatefulWidget {
  final Teacher user;

  const AddDialog({Key? key, required this.user}) : super(key: key);

  @override
  State<AddDialog> createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  DateTime? _selectedDate;
  Subject? _selectedSubject;
  Class? _selectedClass;
  File? _selectedFile;
  String _fileName = '';
  String _title = '';
  String _description = '';
  Widget? _error;

  Future<void> _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    bool check = false;

    if (_selectedClass == null ||
        _selectedDate == null ||
        _selectedSubject == null) {
      setState(() {
        _error = Text('Predmet, Trieda a Dátum sú povinné',
            style: TextStyle(color: Theme.of(context).colorScheme.error));
      });
      check = true;
    }

    if (!isValid || check) {
      return;
    }

    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      String url = '';
      if (_selectedFile != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('homework_attachments')
            .child(_fileName);
        await ref.putFile(_selectedFile!);
        url = await ref.getDownloadURL();
      }

      await FirebaseFirestore.instance.collection('homeworks').add({
        'title': _title,
        'description': _description,
        'deadline': Timestamp.fromDate(_selectedDate!),
        'subject': _selectedSubject!.toEnglishString(),
        'className': _selectedClass!.toEnglishString(),
        'attachmentUrl': url,
        'teacherUCO': widget.user.uco,
      });
    } on FirebaseException catch (e) {
      setState(() {
        _isLoading = false;
        _error = Text(e.message.toString(),
            style: TextStyle(color: Theme.of(context).colorScheme.error));
      });
      return;
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      Navigator.of(context).pop();
    }
  }

  Future<void> _getDate() async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null
            ? _selectedDate!
            : DateTime.now().add(const Duration(days: 1)),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));

    setState(() => _selectedDate = date);
  }

  void _subjectHandler(dynamic subject) {
    setState(
        () => _selectedSubject = subject == null ? null : subject as Subject);
  }

  void _classHandler(dynamic class_) {
    setState(() => _selectedClass = class_ == null ? null : class_ as Class);
  }

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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Nová úloha'),
              IconButton(
                onPressed: _getDate,
                icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _selectedDate != null
                        ? const Icon(Icons.event_available)
                        : const Icon(Icons.today)),
              ),
            ],
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Názov je povinný';
                    }
                    return null;
                  },
                  onSaved: (value) => _title = value!,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Názov',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Popis je povinný';
                    }
                    return null;
                  },
                  onSaved: (value) => _description = value!,
                  textInputAction: TextInputAction.newline,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Popis',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: 250,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownFilterChip(
                        label: const Text('Predmet'),
                        items: Utils.createSubjectsList(widget.user.subjects),
                        onChanged: _subjectHandler,
                        selected: _selectedSubject != null,
                        dropdownOffset: _selectedSubject != null
                            ? const Offset(-106, 0)
                            : const Offset(-88, 0),
                        dropdownWidth: _selectedSubject != null ? 122 : 105,
                      ),
                      DropdownFilterChip(
                        label: const Text('Trieda'),
                        items: Utils.createClassList(widget.user.classes),
                        onChanged: _classHandler,
                        dropdownWidth: _selectedClass != null ? 108 : 90,
                        dropdownOffset: _selectedClass != null
                            ? const Offset(-92, 0)
                            : const Offset(-73, 0),
                        selected: _selectedClass != null,
                      ),
                    ],
                  ),
                ),
                _error ?? const SizedBox(height: 0),
              ],
            ),
          ),
          actions: [
            IconButton(
                onPressed: _pickFile,
                icon: _selectedFile != null
                    ? const Icon(Icons.file_download_done)
                    : const Icon(Icons.attach_file)),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Zrušiť'),
            ),
            TextButton(
              onPressed: () async => await _trySubmit(),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Zadať'),
            ),
          ],
        ),
      ),
    );
  }
}
