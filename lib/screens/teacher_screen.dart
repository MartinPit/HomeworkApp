import 'package:flutter/material.dart';
import 'package:homework_app/widgets/home/home_app_bar.dart';

class TeacherScreen extends StatelessWidget {
  const TeacherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: HomeAppBar(title: 'Úlohy'),
      body: Center(
        child: Text('Teacher'),
      ),);
  }
}
