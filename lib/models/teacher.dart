import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot;
import 'package:flutter/cupertino.dart';
import 'package:homework_app/models/user.dart';

import 'classes.dart';

class Teacher extends User with ChangeNotifier {
  late List<Class> _classes;

  List<Class> get classes => [..._classes];

  Teacher.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) : super.fromSnapshot(snapshot) {
    _classes = snapshot['classes'].map<Class>((e) => Class.values.firstWhere((element) => element.toEnglishString() == e)).toList();
    notifyListeners();
  }

  @override
  void clear() {
    super.clear();
    _classes = [];
    notifyListeners();
  }
}