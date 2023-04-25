import 'package:cloud_firestore/cloud_firestore.dart'
    show QueryDocumentSnapshot, Timestamp;
import 'package:flutter/cupertino.dart';

import 'grade.dart';

class Submission with ChangeNotifier {
  late final String id;
  late final String studentUCO;
  late final String studentName;
  late final String studentSurname;
  late final String teacherUCO;
  late final String homeworkId;
  late final String attachmentUrl;
  late final String note;
  late final DateTime submittedAt;
  late final Grade grade;

  Submission({
    required this.id,
    required this.studentUCO,
    required this.studentName,
    required this.studentSurname,
    required this.teacherUCO,
    required this.homeworkId,
    this.attachmentUrl = '',
    required this.note,
    required this.submittedAt,
    this.grade = Grade.none,
  });

  Submission.fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
    id = snapshot.id;

    final data = snapshot.data();
    studentUCO = data['studentUCO'];
    studentName = data['studentName'];
    studentSurname = data['studentSurname'];
    teacherUCO = data['teacherUCO'];
    homeworkId = data['homeworkId'];
    attachmentUrl = data['attachmentUrl'];
    note = data['note'];
    submittedAt = (data['submittedAt'] as Timestamp).toDate();
    grade = Grade.values
        .firstWhere((element) => element.toEnglishString() == data['grade'], orElse: () => Grade.none);
  }
}
