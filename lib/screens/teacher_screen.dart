import 'package:flutter/material.dart';
import 'package:homework_app/widgets/home/assigned_homeworks.dart';
import 'package:homework_app/widgets/home/home_app_bar.dart';

import '../widgets/home/submitted_homeworks.dart';

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({Key? key}) : super(key: key);

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  int _selectedIndex = 0;
  List<Map<String, Object>> pages = [
    {'page': const AssignedHomeworks(), 'title': 'Zadané úlohy'},
    {'page': const SubmittedHomeworks(), 'title': 'Odovzdané úlohy'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(title: pages[_selectedIndex]['title'] as String, isStudent: false),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(20),
          child: pages[_selectedIndex]['page'] as Widget),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.text_snippet_outlined),
              label: 'Zadané',
              selectedIcon: Icon(Icons.text_snippet)),
          NavigationDestination(
              icon: Icon(Icons.task_outlined),
              label: 'Odovzdané',
              selectedIcon: Icon(Icons.task)),
        ],
      ),
    );
  }
}
