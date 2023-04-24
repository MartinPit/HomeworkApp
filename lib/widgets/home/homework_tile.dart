import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/homework.dart';
import '../../models/student.dart';

class HomeworkTile extends StatelessWidget {
  final bool submittedSelected;
  final bool scoredSelected;
  final bool isTeacher;

  const HomeworkTile(
      {Key? key,
      this.isTeacher = false,
      this.scoredSelected = false,
      this.submittedSelected = false})
      : super(key: key);

  List<dynamic> getSubmission(Homework data, BuildContext context) {
    QueryDocumentSnapshot<Map<String, dynamic>>? result;
    FirebaseFirestore.instance
        .collection('submissions')
        .where('homeworkId', isEqualTo: data.id)
        .where('studentUCO',
            isEqualTo: isTeacher
                ? null
                : Provider.of<Student>(context, listen: false).uco)
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        result = null;
        return result;
      }

      result = value.docs.first;
      return result;
    });
    bool hide = false;
    if (submittedSelected && result == null) {
      hide = true;
    }

    if (scoredSelected &&
        (result == null || result != null && result!['grade'] == null)) {
      hide = true;
    }

    return [result, hide];
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Homework>(context);
    final result = getSubmission(data, context);
    final QueryDocumentSnapshot<Map<String, dynamic>>? submission = result[0];
    final bool hide = result[1];
    print(submittedSelected);
    return GestureDetector(
      child: hide
          ? Container()
          : Card(
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
                            ? Text('')
                            : Text(submission!['grade'].toString(),
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
    );
  }
}
