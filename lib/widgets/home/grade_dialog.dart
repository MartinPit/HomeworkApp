import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:homework_app/models/submission.dart';

import '../../models/grade.dart';

class GradeDialog extends StatefulWidget {
  final Submission submission;

  const GradeDialog({Key? key, required this.submission}) : super(key: key);

  @override
  State<GradeDialog> createState() => _GradeDialogState();
}

class _GradeDialogState extends State<GradeDialog> {
  bool _isLoading = false;
  String _grade = 'FX';
  double _value = 0.0;

  void changeGrade(double value) {
    setState(() {
      _value = value;
    });

    switch (value.toInt()) {
      case 0:
        setState(() => _grade = 'FX');
        break;
      case 1:
        setState(() => _grade = 'E');
        break;
      case 2:
        setState(() => _grade = 'D');
        break;
      case 3:
        setState(() => _grade = 'C');
        break;
      case 4:
        setState(() => _grade = 'B');
        break;
      case 5:
        setState(() => _grade = 'A');
        break;
    }
  }

  Future<void> submitGrade() async {
    setState(() => _isLoading = true);

    try {
      FirebaseFirestore.instance
          .collection('submissions')
          .doc(widget.submission.id)
          .update({
        'grade': _grade,
      });
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message!),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() => widget.submission.grade.toEnglishString());

    return AlertDialog(
      icon: const Icon(Icons.verified),
      title: const Text('Vyberte známku'),
      content: Container(
        margin: const EdgeInsets.only(top: 30),
        height: 10,
        child: Slider(
          value: _value,
          onChanged: changeGrade,
          min: 0,
          max: 5,
          divisions: 5,
          label: _grade,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Zrušit'),
        ),
        TextButton(
          onPressed: () async {
            await submitGrade();
            Navigator.of(context).pop(true);
          },
          child: _isLoading
              ? const CircularProgressIndicator()
              : const Text('Potvrdit'),
        ),
      ],
    );
  }
}
