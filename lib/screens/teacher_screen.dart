import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class TeacherScreen extends StatelessWidget {
  const TeacherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [IconButton(
          onPressed: () async {
            Provider.of<User>(context, listen: false).clear();
            FirebaseAuth.instance.signOut();
          },
          icon: const Icon(Icons.logout),
        ),],
      ),
      body: const Center(
        child: Text('Teacher'),
      ),);
  }
}
