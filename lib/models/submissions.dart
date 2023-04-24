import 'package:flutter/cupertino.dart';
import 'package:homework_app/models/submission.dart';

class Submissions with ChangeNotifier {
  final List<Submission> _submissions = [
    Submission(
        id: '1',
        studentName: 'Martin Oliver',
        studentSurname: 'Pitoňák',
        studentUCO: '524916',
        teacherUCO: "2116",
        homeworkId: 'a',
        note: 'Dsc1',
        submittedAt: DateTime.now()),
    Submission(
        id: '2',
        studentName: 'Martin Oliver',
        studentSurname: 'Pitoňák',
        studentUCO: '524916',
        teacherUCO: "2116",
        homeworkId: 'b',
        note: 'Dsc2',
        submittedAt: DateTime.now()),
  ];

  List<Submission> get submissions {
    return [..._submissions];
  }

  void addSubmission(Submission submission) {
    _submissions.add(submission);
    notifyListeners();
  }
}
