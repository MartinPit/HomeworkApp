import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:homework_app/models/subjects.dart';
import 'package:intl/intl.dart';

import '../models/homework.dart';
import '../models/submission.dart';

class SubmissionScreen extends StatefulWidget {
  static const routeName = '/submission_screen';

  const SubmissionScreen({Key? key}) : super(key: key);

  @override
  State<SubmissionScreen> createState() => _SubmissionScreenState();
}

class _SubmissionScreenState extends State<SubmissionScreen> {
  File? _selectedFile;
  String _fileName = '';

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

  void _downloadFile(String url) async {
    FlutterDownloader.registerCallback(downloadCallback);

    @pragma('vm:entry-point')
    final taskId = await FlutterDownloader.enqueue(
      url: url,
      savedDir: '/storage/emulated/0/Download',
      saveInPublicStorage: true,
      showNotification: true,
      // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Súbor bude uložený v priečinku "Downloads"'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    // print(
    //     'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');

    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    final options = ModalRoute.of(context)!.settings.arguments as List;
    final Homework data = options[0];
    final Submission? submission = options[1];

    return Scaffold(
      appBar: AppBar(
        title: Text(data.title),
        actions: [
          IconButton(
            onPressed: _pickFile,
            icon: _selectedFile != null
                ? const Icon(Icons.file_download_done)
                : const Icon(Icons.attach_file),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    data.subject.toEnglishString(),
                    style: Theme.of(context).textTheme.titleMedium,
                  )),
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.topLeft,
                width: 500,
                height: 150,
                child: Text(
                  data.description,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                alignment: Alignment.centerRight,
                child: FilledButton.tonalIcon(
                  onPressed: () => _downloadFile(data.attachmentUrl),
                  icon: const Icon(Icons.file_download_outlined),
                  label: const Text('Stiahnuť zadanie'),
                ),
              ),
              const SizedBox(height: 20),
              const Divider(),
              Text(DateFormat('dd.M.yyyy').format(data.deadline),
                  style: Theme.of(context).textTheme.headlineSmall),
              const Divider(),
              const SizedBox(height: 20),
              Form(
                child: Container(
                  height: 200,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.surfaceVariant,
                  ),
                  child: TextFormField(
                    maxLines: 10,
                    decoration: const InputDecoration(
                      hintText: 'Napíšte sem svoju odpoveď',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton.extended(
          onPressed: () {},
          label: const Text('Odovzdať'),
          icon: const Icon(Icons.check),
        ),
      ),
    );
  }
}
