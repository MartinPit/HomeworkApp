import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String _uco = '';
  String _name = '';
  String _surname = '';
  Role? _role;


  String get uco => _uco;

  String get name => _name;

  String get surname => _surname;

  void init() {
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
      _uco = value['uco'];
      _name = value['name'];
      _surname = value['surname'];
      _role = value['role'] == 'teacher' ? Role.teacher : Role.student;
      notifyListeners();
    });
  }

  void clear() {
    _uco = '';
    _name = '';
    _role = null;
    _surname = '';
    notifyListeners();
  }

  bool isStudent() {
    return _role == Role.student;
  }
}