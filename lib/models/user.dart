import 'package:flutter/material.dart';

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

class User with ChangeNotifier {
  String uco = '';
  String name = '';
  Role? role;
  List<String> subjects = [];

  User();

  void init(String uco, String name, Role role) {
    this.uco = uco;
    this.name = name;
    this.role = role;
  }

  void clear() {
    uco = '';
    name = '';
    role = null;
    subjects = [];
  }
}