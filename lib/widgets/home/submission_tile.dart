import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:homework_app/models/classes.dart';
import 'package:homework_app/models/subjects.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/grade.dart';
import '../../models/homework.dart';
import '../../models/submission.dart';

class SubmissionTile extends StatefulWidget {
  final void Function()? refresh;
  final String? class_;
  final String? subject;
  final String title;


  const SubmissionTile({Key? key, this.refresh, required this.class_, required this.subject, required this.title}) : super(key: key);

  @override
  State<SubmissionTile> createState() => _SubmissionTileState();
}

class _SubmissionTileState extends State<SubmissionTile> {
  bool hide = false;

  Future<void> filter(Submission data, BuildContext context, String? class_, String? subject, String title) async {
    final Homework homework = await FirebaseFirestore.instance
        .collection('homeworks')
        .doc(data.homeworkId)
        .get()
        .then((value) => Homework.fromDoc(value));

    if (class_ != null && homework.className.toEnglishString() != class_) {
      hide = true;
      return;
    }

    if (subject != null && homework.subject.toEnglishString() != subject) {
      hide = true;
      return;
    }

    if (title != '' && !homework.title.toLowerCase().contains(title.toLowerCase())) {
      hide = true;
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Submission>(context);
    return FutureBuilder(
      future: filter(data, context, widget.class_, widget.subject, widget.title),
      builder:(_, snapshot) => hide ? const SizedBox() : GestureDetector(
        onTap: () async {
          final result = await Navigator.of(context).pushNamed(
            '/grading_screen',
            arguments: data,
          );

          if (result != null) {
            widget.refresh?.call();
          }
        },
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: const Icon(
                    Icons.class_,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${data.studentName} ${data.studentSurname}',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 5),
                    Text(DateFormat('d. MMMM y').format(data.submittedAt),
                        style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(data.grade.toEnglishString(),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.error)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
