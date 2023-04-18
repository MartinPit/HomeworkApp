import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/person.dart';
import '../widgets/auth/login_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Role _roleSelection = Role.student;

  Future<void> _tryLogin(String uco, String password) async {
    final user = await FirebaseFirestore.instance.collection('users').doc(uco).get();
    if (!user.exists) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Používateľ neexistuje'),
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }

    if (user['role'] != _roleSelection.toEnglishString()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Nesprávna rola'),
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }

    try {
      FirebaseAuth.instance.signInWithEmailAndPassword(email: user['email'], password: password);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message ?? 'Nastala chyba'),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 190,
                  height: 190,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image:
                              AssetImage('assets/avatars/3d_avatar_20avatar.png'),
                          fit: BoxFit.cover)),
                ),
                const SizedBox(
                  height: 40,
                ),
                SegmentedButton<Role>(
                  segments: [
                    ButtonSegment<Role>(
                      value: Role.student,
                      label: Text(Role.student.toSlovakString()),
                      icon: const Icon(Icons.person_outline_outlined),
                    ),
                    ButtonSegment<Role>(
                      value: Role.teacher,
                      label: Text(Role.teacher.toSlovakString()),
                      icon: const Icon(Icons.supervisor_account_outlined),
                    ),
                  ],
                  selected: {_roleSelection},
                  emptySelectionAllowed: false,
                  multiSelectionEnabled: false,
                  onSelectionChanged: (Set<Role> newSelection) =>
                      setState(() => _roleSelection = newSelection.first),
                ),
                const SizedBox(
                  height: 15,
                ),
                LoginForm(handler: _tryLogin),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
