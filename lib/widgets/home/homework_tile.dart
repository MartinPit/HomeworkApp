import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:homework_app/screens/submission_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/grade.dart';
import '../../models/homework.dart';
import '../../models/student.dart';
import '../../models/submission.dart';
import '../../models/teacher.dart';

class HomeworkTile extends StatefulWidget {
  final bool submittedSelected;
  final bool scoredSelected;
  final bool isTeacher;

  const HomeworkTile(
      {Key? key,
      this.isTeacher = false,
      this.scoredSelected = false,
      this.submittedSelected = false})
      : super(key: key);

  @override
  State<HomeworkTile> createState() => _HomeworkTileState();
}

class _HomeworkTileState extends State<HomeworkTile> {
  Submission? submission;
  bool hide = false;

  Future<void> getSubmission(Homework data, BuildContext context) async {
    final response = await FirebaseFirestore.instance
        .collection('submissions')
        .where('homeworkId', isEqualTo: data.id)
        .where('studentUCO',
            isEqualTo: widget.isTeacher
                ? null
                : Provider.of<Student>(context, listen: false).uco)
        .get();
    if (widget.submittedSelected && response.docs.isEmpty) {
      hide = true;
    }

    final result = response.docs.isEmpty ? null : response.docs.first;

    if (widget.scoredSelected &&
        (result == null || result['grade'] == null)) {
      hide = true;
    }

    if (result == null) {
      submission = null;
    } else {
      submission = Submission.fromDoc(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Homework>(context);
    final user;
    if (!widget.isTeacher) {
      user = Provider.of<Student>(context, listen: false);
    } else {
      user = Provider.of<Teacher>(context, listen: false);
    }
    return FutureBuilder(
      future: getSubmission(data, context),
      builder: (context, _) => hide
          ? Container()
          : GestureDetector(
              onTap: widget.isTeacher ? null : () => Navigator.pushNamed(
                  context, SubmissionScreen.routeName,
                  arguments: [data, submission, user]),
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
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
                          Text(data.title,
                              style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 5),
                          Text(DateFormat('d. MMMM y').format(data.deadline),
                              style: Theme.of(context).textTheme.labelSmall),
                        ],
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: submission == null
                              ? const Text('')
                              : Text((submission == null || submission!.grade == Grade.none) ? '' : submission!.grade.toEnglishString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error)),
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
