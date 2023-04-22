import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homework_app/models/classes.dart';
import 'package:homework_app/models/student.dart';
import 'package:homework_app/models/subjects.dart';
import 'package:homework_app/models/teacher.dart';

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

class User with ChangeNotifier implements Student, Teacher {
  String _uco = '';
  String _name = '';
  String _surname = '';
  Role? _role;
  Class? _class;
  List<Subject>? _subjects;
  List<Class>? _classes;


  @override
  String get uco => _uco;

  @override
  String get name => _name;

  @override
  String get surname => _surname;

  @override
  Class get class_ => _class!;

  @override
  List<Subject> get subjects => [..._subjects!];

  @override
  List<Class> get classes => [..._classes!];

  Future<void> init() async {
    final value = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    _uco = value['uco'];
    _name = value['name'];
    _surname = value['surname'];
    _role = value['role'] == 'teacher' ? Role.teacher : Role.student;
    if (_role == Role.student) {
      _class = Class.values.firstWhere((element) => element.toEnglishString() == value['class']);
      _subjects = value['subjects'].map<Subject>((e) => Subject.values.firstWhere((element) => element.toEnglishString() == e)).toList();
    } else {
      _classes = value['classes'].map<Class>((e) => Class.values.firstWhere((element) => element.toEnglishString() == e)).toList();
      _subjects = value['subjects'].map<Subject>((e) => Subject.values.firstWhere((element) => element.toEnglishString() == e)).toList();
    }
    notifyListeners();
  }

  @override
  void clear() {
    _uco = '';
    _name = '';
    _role = null;
    _surname = '';
    notifyListeners();
  }

  @override
  bool isStudent() {
    return _role == Role.student;
  }
}