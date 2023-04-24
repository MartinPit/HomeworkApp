import 'package:cloud_firestore/cloud_firestore.dart' show QueryDocumentSnapshot, Timestamp;
import 'package:flutter/foundation.dart';
import 'package:homework_app/models/subjects.dart';

import 'classes.dart';

class Homework with ChangeNotifier {
  late String id;
  late String title;
  late String description;
  late String teacherUCO;
  late DateTime deadline;
  late Subject subject;
  late Class className;
  late String attachmentUrl;

  Homework({
    required this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.subject,
    required this.className,
    required this.teacherUCO,
    this.attachmentUrl = '',
  });

  Homework.fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    id = doc.id;

    final data = doc.data();

    title = data['title'];
    description = data['description'];
    deadline = (data['deadline'] as Timestamp).toDate();
    subject = Subject.values.firstWhere((element) => element.toEnglishString() == data['subject']);
    className = Class.values.firstWhere((element) => element.toEnglishString() == data['className']);
    teacherUCO = data['teacherUCO'];
    attachmentUrl = data['attachmentUrl'];
  }
}
