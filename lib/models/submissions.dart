import 'package:flutter/cupertino.dart';
import 'package:homework_app/models/submission.dart';

class Submissions with ChangeNotifier {
  final List<Submission> _submissions = [
    Submission(id: 'a', studentName: 'Martin Oliver Pitoňák',studentUCO: '524916', teacherUCO: "2116", homeworkId: 'a', description: 'Dsc1'),
    Submission(id: 'b', studentName: 'Martin Oliver Pitoňák', studentUCO: '524916', teacherUCO: "2116", homeworkId: 'b', description: 'Dsc2'),
  ];

  List<Submission> get submissions {
    return [..._submissions];
  }

  void addSubmission(Submission submission) {
    _submissions.add(submission);
    notifyListeners();
  }
}