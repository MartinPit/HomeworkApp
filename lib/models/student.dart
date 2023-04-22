import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot;
import 'package:flutter/cupertino.dart';
import 'package:homework_app/models/user.dart';

import 'classes.dart';

class Student extends User with ChangeNotifier {
  late Class? _class;

  Class get class_ => _class!;

  Student.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) : super.fromSnapshot(snapshot) {
    _class = Class.values.firstWhere((element) => element.toEnglishString() == snapshot['class']);
    notifyListeners();
  }

  void clear() {
super.clear();
    _class = null;
    notifyListeners();
  }
}