import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:homework_app/models/homework.dart';
import 'package:homework_app/widgets/home/dropdown_chip.dart';
import 'package:provider/provider.dart';

import '../../models/classes.dart';
import '../../models/subjects.dart';
import '../../models/teacher.dart';
import '../../utils.dart';
import 'homework_tile.dart';

class AssignedHomeworks extends StatefulWidget {
  const AssignedHomeworks({Key? key}) : super(key: key);

  @override
  State<AssignedHomeworks> createState() => _AssignedHomeworksState();
}

class _AssignedHomeworksState extends State<AssignedHomeworks> {
  late final Teacher user;
  String? subjectFilter;
  String? classFilter;

  @override
  void initState() {
    super.initState();
    user = Provider.of<Teacher>(context, listen: false);
  }

  void subjectHandler(dynamic subject) {
    setState(() => subjectFilter =
        subject == null ? null : (subject as Subject).toEnglishString());
  }

  void classHandler(dynamic class_) {
    // print((class_ as Class).toEnglishString());
    setState(() => classFilter =
        class_ == null ? null : (class_ as Class).toEnglishString());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                onChanged: subjectHandler,
                selected: subjectFilter != null,
                dropdownWidth: subjectFilter != null ? 122 : 105,
                dropdownOffset: subjectFilter != null
                    ? const Offset(-106, 0)
                    : const Offset(-88, 0),
              ),
              const SizedBox(width: 7),
              DropdownFilterChip(
                  label: const Text('Trieda'),
                  items: Utils.createClassList(user.classes),
                  onChanged: classHandler,
                  dropdownWidth: classFilter != null ? 108 : 90,
                  dropdownOffset: classFilter != null
                      ? const Offset(-92, 0)
                      : const Offset(-73, 0),
                  selected: classFilter != null),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('homeworks')
                .where('teacherUCO', isEqualTo: user.uco)
                .where('className', isEqualTo: classFilter)
                .where('subject', isEqualTo: subjectFilter)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                itemBuilder: (context, index) =>
                    ChangeNotifierProvider<Homework>(
                  create: (context) =>
                      Homework.fromDoc(snapshot.data!.docs[index]),
                  child: const HomeworkTile(
                    isHomework: true,
                  ),
                ),
                itemCount: snapshot.data!.docs.length,
              );
            },
          ),
        ),
      ],
    );
  }
}
