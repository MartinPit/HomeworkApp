import 'package:homework_app/models/subjects.dart';
import 'package:homework_app/models/user.dart' show Role;

import 'classes.dart';

abstract class Student {
  late String _uco;
  late String _name;
  late String _surname;
  late Role _role;
  late Class _class;
  late List<Subject> _subjects;


  String get uco => _uco;
  String get name => _name;
  String get surname => _surname;
  Class get class_ => _class;
  List<Subject> get subjects => [..._subjects];

  bool isStudent();

  void clear();
}