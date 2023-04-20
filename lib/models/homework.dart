import 'package:flutter/foundation.dart';
import 'package:homework_app/models/subjects.dart';
import 'package:homework_app/models/submission.dart';

import 'classes.dart';

class Homework with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String teacherUCO;
  final DateTime deadline;
  final Subject subject;
  final Class className;
  final String attachmentUrl;
  final List<Submission> submissions;

  Homework({
    required this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.subject,
    required this.className,
    required this.teacherUCO,
    this.attachmentUrl = '',
    this.submissions = const [],
  });
}
