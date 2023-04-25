import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/grade.dart';
import '../../models/submission.dart';

class SubmissionTile extends StatelessWidget {
  final void Function()? refresh;

  const SubmissionTile({Key? key, this.refresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Submission>(context);
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.of(context).pushNamed(
          '/grading_screen',
          arguments: data,
        );

        if (result != null) {
          refresh?.call();
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
                  child: Text(
                      data.grade != null ? data.grade!.toEnglishString() : '',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.error)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
