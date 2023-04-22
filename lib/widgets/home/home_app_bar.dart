import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:homework_app/models/teacher.dart';
import 'package:provider/provider.dart';

import '../../models/student.dart';
import '../../models/user.dart';
import '../../screens/profile_screen.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isStudent;

  const HomeAppBar({Key? key, required this.title, required this.isStudent})
      : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        IconButton(
            onPressed: () => Navigator.of(context)
                .pushNamed(ProfileScreen.routeName, arguments: isStudent),
            icon: const Icon(Icons.account_circle_outlined)),
        IconButton(
          onPressed: () async {
            isStudent
                ? Provider.of<Student>(context, listen: false).clear()
                : Provider.of<Teacher>(context, listen: false).clear();
            FirebaseAuth.instance.signOut();
          },
          icon: const Icon(Icons.logout),
        ),
      ],
    );
  }
}
