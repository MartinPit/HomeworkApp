import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:homework_app/models/grade.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/homework.dart';
import '../../models/submission.dart';

class HomeworkTile extends StatelessWidget {
  final bool isHomework;

  const HomeworkTile({Key? key, required this.isHomework}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = isHomework
        ? Provider.of<Homework>(context)
        : Provider.of<Submission>(context);
    return GestureDetector(
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
                  Text(
                      isHomework
                          ? (data as Homework).title
                          : (data as Submission).studentName,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 5),
                  Text(
                      DateFormat('d. MMMM y').format(isHomework
                          ? (data as Homework).deadline
                          : (data as Submission).submittedAt),
                      style: Theme.of(context).textTheme.labelSmall),
                ],
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: !isHomework
                      ? Text((data as Submission).grade != Grade.none ? data.grade.toString() : '',
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Theme.of(context).colorScheme.error))
                      : FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('submissions')
                              .where('homeworkId', isEqualTo: (data as Homework).id)
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.waiting ||
                                !snapshot.hasData ||
                                snapshot.error != null) {
                              return Text('');
                            }
                            return snapshot.data!.docs.isEmpty
                                ? Text('')
                                : Text(
                                    snapshot.data!.docs.first['grade']
                                        .toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error));
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
