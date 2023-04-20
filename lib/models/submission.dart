import 'package:flutter/cupertino.dart';

import 'grade.dart';

class Submission with ChangeNotifier {
  final String id;
  final String studentUCO;
  final String homeworkId;
  final String attachmentUrl;
  final String description;
  final DateTime submittedAt = DateTime.now();
  final Grade grade;

  Submission({
    required this.id,
    required this.studentUCO,
    required this.homeworkId,
    this.attachmentUrl = '',
    this.description = '',
    this.grade = Grade.none,
  });
}