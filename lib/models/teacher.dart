import 'package:homework_app/models/subjects.dart';
import 'package:homework_app/models/user.dart';

import 'classes.dart';

abstract class Teacher {
  late String _uco;
  late String _name;
  late String _surname;
  late Role _role;
  late List<Subject> _subjects;
  late List<Class> _classes;

  String get uco => _uco;
  String get name => _name;
  String get surname => _surname;
  List<Subject> get subjects => [..._subjects];
  List<Class> get classes => [..._classes];

  bool isStudent();

  void clear();
}