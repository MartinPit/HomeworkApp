import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:homework_app/screens/profile_screen.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final user;

  @override
  void initState() {
    super.initState();
    user = Provider.of<User>(context, listen: false)..init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(ProfileScreen.routeName),
              icon: const Icon(Icons.account_circle_outlined)),
          IconButton(
            onPressed: () async {
              user.clear();
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const Center(
        child: Text('Home'),
      ),
    );
  }
}
