import 'package:flutter/material.dart';
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
}