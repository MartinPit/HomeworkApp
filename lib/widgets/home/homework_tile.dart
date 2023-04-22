import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/homework.dart';

class HomeworkTile extends StatelessWidget {
  const HomeworkTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homework = Provider.of<Homework>(context);
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
                  Text(homework.title,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 5),
                  Text(DateFormat('d. MMMM y').format(homework.deadline),
                      style: Theme.of(context).textTheme.labelSmall),
                ],
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('submissions')
                        .where('homeworkId', isEqualTo: homework.id)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting || !snapshot.hasData || snapshot.error != null) {
                        return Text('...', style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.error));
                      }
                      return snapshot.data!.docs.isEmpty
                          ? Text('')
                          : Text(
                          snapshot.data!.docs.first['grade'].toString(),
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.error));
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
