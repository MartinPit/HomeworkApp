import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:homework_app/models/classes.dart';

import 'models/subjects.dart';

const maxFileSize = 200 * 1024 * 1024;

class Utils {

  static List<DropdownMenuItem> createClassList(List<Class> items) {
    final List<DropdownMenuItem> result = [const DropdownMenuItem(value: null,child: Text('zrušiť'),)];

    for (Class item in items) {
      result.add(DropdownMenuItem(value: item,child: Text(item.toEnglishString()),));
    }

    return result;
  }

  static List<DropdownMenuItem> createSubjectsList(List<Subject> items) {
    final List<DropdownMenuItem> result = [const DropdownMenuItem(value: null,child: Text('zrušiť'),)];

    for (Subject item in items) {
      result.add(DropdownMenuItem(value: item,child: Text(item.toEnglishString()),));
    }

    return result;
  }

  static bool isFileTooBig(int size) {
    return size > maxFileSize;
  }

  static void downloadFile(String url, BuildContext context) async {
    FlutterDownloader.registerCallback(Utils.downloadCallback);

    @pragma('vm:entry-point')
    final _ = await FlutterDownloader.enqueue(
      url: url,
      savedDir: '/storage/emulated/0/Download',
      saveInPublicStorage: true,
      showNotification: true,
      openFileFromNotification: true,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Súbor bude uložený v priečinku "Downloads"'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
    IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }
}