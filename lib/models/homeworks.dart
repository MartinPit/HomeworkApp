import 'package:flutter/foundation.dart';
import 'package:homework_app/models/classes.dart';
import 'package:homework_app/models/subjects.dart';

import 'homework.dart';

class Homeworks with ChangeNotifier {
  final List<Homework> _homeworks = [
    Homework(id: 'a', title: 'Test1', description: 'Dsc1', deadline: DateTime.now(), subject: Subject.Low_Level_Programming, className: Class.nineA, teacherUCO: '2116'),
    Homework(id: 'b', title: 'Test2', description: 'Dsc2', deadline: DateTime.now(), subject: Subject.Assembly, className: Class.nineA, teacherUCO: '2116'),
  ];


  List<Homework> get homeworks => [..._homeworks];
}