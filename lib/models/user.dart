import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot;
import 'package:homework_app/models/subjects.dart';

enum Role {
  teacher, student
}

extension Stringifier on Role {
  String toSlovakString() {
    if (this == Role.teacher) {
      return 'Učiteľ';
    }
    return 'Študent';
  }

  String toEnglishString() {
    if (this == Role.teacher) {
      return 'teacher';
    }
    return 'student';
  }
}

class User{
  String _uco = '';
  String _name = '';
  String _surname = '';
  List<Subject>? _subjects;


  String get uco => _uco;

  String get name => _name;

  String get surname => _surname;

  List<Subject> get subjects => [..._subjects!];

  User.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    _uco = snapshot['uco'];
    _name = snapshot['name'];
    _surname = snapshot['surname'];
    _subjects = snapshot['subjects'].map<Subject>((e) => Subject.values.firstWhere((element) => element.toEnglishString() == e)).toList();
  }

  void clear() {
    _uco = '';
    _name = '';
    _surname = '';
    _subjects = null;
  }
}