import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:intl/intl.dart';

import '../models/submission.dart';
import '../widgets/home/grade_dialog.dart';

class GradingScreen extends StatelessWidget {
  static const routeName = '/grading_screen';

  const GradingScreen({Key? key}) : super(key: key);

  void _downloadFile(String url, BuildContext context) async {
    FlutterDownloader.registerCallback(downloadCallback);

    @pragma('vm:entry-point')
    final _ = await FlutterDownloader.enqueue(
      url: url,
      savedDir: '/storage/emulated/0/Download',
      saveInPublicStorage: true,
      showNotification: true,
      openFileFromNotification: true,
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
    final submission = ModalRoute.of(context)!.settings.arguments as Submission;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Odovzdaná úloha'),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
                alignment: Alignment.centerLeft,
                child: Text(
                    '${submission.studentName} ${submission.studentSurname}',
                    style: Theme.of(context).textTheme.titleLarge)),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                submission.studentUCO,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                DateFormat("dd.M.yyyy").format(submission.submittedAt),
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              height: 150,
              alignment: Alignment.topLeft,
              child: Container(
                  width: 250,
                  child: Text(
                    submission.note,
                    style: Theme.of(context).textTheme.labelLarge,
                  )),
            ),
            const SizedBox(height: 20),
            Container(
              alignment: Alignment.centerRight,
              child: FilledButton.tonalIcon(
                onPressed: submission.attachmentUrl == ''
                    ? null
                    : () => _downloadFile(submission.attachmentUrl, context),
                icon: const Icon(Icons.file_download_outlined),
                label: const Text('Stiahnuť vypracovanie'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton.extended(
          onPressed: () async {
            bool? result = await showDialog<bool>(context: context, builder: (context) => GradeDialog(submission: submission),);
            if (result != null && result) {
              Navigator.of(context).pop(true);
            }
          },
          label: const Text('Ohodnotiť'),
          icon: const Icon(Icons.mode_comment_outlined),
        ),
      ),
    );
  }
}
