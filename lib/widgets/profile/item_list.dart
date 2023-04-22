import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';

import '../../models/user.dart';

class ItemList extends StatelessWidget {
  final User user;
  final bool isStudent;
  const ItemList({Key? key, required this.user, required this.isStudent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, bottom: 4),
            child: Text(
              isStudent ? 'Predmety' : 'Triedy',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).colorScheme.secondaryContainer,
            ),
            child: FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }
                  final data = isStudent
                      ? snapshot.data!['subjects']
                      : snapshot.data!['classes'];
                  return ListView.separated(
                    itemBuilder: (context, index) => ListTile(
                      visualDensity: const VisualDensity(vertical: -4),
                      title: Text(data[index],
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer)),
                    ),
                    separatorBuilder: (context, index) => Divider(
                        color: Theme.of(context)
                            .colorScheme
                            .onSecondaryContainer),
                    itemCount: data.length,
                  );
                }),
          ),
        ],
      ),
    );
  }
}
