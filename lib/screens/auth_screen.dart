import 'package:flutter/material.dart';

import '../models/person.dart';
import '../widgets/auth/login_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Role roleSelection = Role.student;

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
                  selected: {roleSelection},
                  emptySelectionAllowed: false,
                  multiSelectionEnabled: false,
                  onSelectionChanged: (Set<Role> newSelection) =>
                      setState(() => roleSelection = newSelection.first),
                ),
                const SizedBox(
                  height: 15,
                ),
                const LoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
