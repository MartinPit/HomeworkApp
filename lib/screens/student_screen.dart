import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:homework_app/models/classes.dart';
import 'package:homework_app/models/homeworks.dart';
import 'package:homework_app/widgets/home/dropdown_chip.dart';
import 'package:homework_app/widgets/home/home_app_bar.dart';
import 'package:provider/provider.dart';

import '../models/homework.dart';
import '../models/student.dart';
import '../models/subjects.dart';
import '../utils.dart';
import '../widgets/home/homework_tile.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({Key? key}) : super(key: key);

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  late final Student user;
  bool _submittedSelected = false;
  DateTime? _dateFilter;
  Subject? _subjectFilter;
  bool _scoredSelected = false;

  @override
  void initState() {
    super.initState();
    user = Provider.of<Student>(context, listen: false);
  }

  void _dateHandler() {
    showDatePicker(
      context: context,
      initialDate: _dateFilter == null ? DateTime.now() : _dateFilter!,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    ).then((value) {
      setState(() => _dateFilter = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeworkList = Provider.of<Homeworks>(context)
        .homeworks
        .where((element) => element.className == user.class_)
        .toList();
    return Scaffold(
      appBar: const HomeAppBar(title: 'Úlohy', isStudent: true),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                children: [
                  DropdownFilterChip(
                    label: const Text('Predmet'),
                    items: Utils.createSubjectsList(user.subjects),
                    onChanged: (value) {
                      setState(() {
                        _subjectFilter = value as Subject?;
                      });
                    },
                    selected: _subjectFilter != null,
                    dropdownOffset: _subjectFilter != null
                        ? const Offset(-106, 0)
                        : const Offset(-88, 0),
                    dropdownWidth: _subjectFilter != null ? 122 : 105,
                  ),
                  const SizedBox(width: 7),
                  FilterChip(
                      label: const Text('Odovzdané'),
                      onSelected: (_) {
                        setState(() {
                          _submittedSelected = !_submittedSelected;
                        });
                      },
                      selected: _submittedSelected),
                  const SizedBox(width: 7),
                  InputChip(
                    label: const Text('Dátum'),
                    avatar: _dateFilter != null
                        ? null
                        : Icon(
                            Icons.today,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    onPressed: _dateHandler,
                    selected: _dateFilter != null,
                  ),
                  const SizedBox(width: 7),
                  FilterChip(
                      label: const Text('Ohodnotené'),
                      onSelected: (_) =>
                          setState(() => _scoredSelected = !_scoredSelected),
                      selected: _scoredSelected),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('homeworks')
                    .where('className',
                        isEqualTo: user.class_.toEnglishString())
                    .where('subject',
                        isEqualTo: _subjectFilter?.toEnglishString())
                    .where('deadline', isEqualTo: _dateFilter)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) =>
                        ChangeNotifierProvider<Homework>(
                      create: (context) =>
                          Homework.fromDoc(snapshot.data!.docs[index]),
                      child: HomeworkTile(scoredSelected: _scoredSelected, submittedSelected: _submittedSelected),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
