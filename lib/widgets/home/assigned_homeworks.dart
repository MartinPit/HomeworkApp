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
    setState(() => classFilter =
        class_ == null ? null : (class_ as Class).toEnglishString());
  }

  void refresh() {
    setState(() {});
  }

  void _deleteHomework(BuildContext ctx, String id) async {
    FirebaseFirestore.instance
        .collection('homeworks')
        .doc(id)
        .delete()
        .catchError((error) => ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(content: Text('Nepodarilo sa vymazať úlohu'))));

    FirebaseFirestore.instance
        .collection('submissions')
        .where('homeworkId', isEqualTo: id)
        .get()
        .then((value) {
      for (var element in value.docs) {
        element.reference.delete();
      }
    }).catchError((error) {
      ScaffoldMessenger.of(ctx)
          .showSnackBar(SnackBar(content: Text('Nepodarilo sa vymazať úlohu')));
    });
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
                selected: classFilter != null,
              ),
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
                  child: Container(
                    child: Dismissible(
                      onDismissed: (direction) => _deleteHomework(
                          context, snapshot.data!.docs[index].id),
                      confirmDismiss: (_) async => await showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Vymazať úlohu?'),
                          content: const Text(
                              'Naozaj si prajete vymazať túto úlohu?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Nie'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Áno'),
                            ),
                          ],
                        ),
                      ),
                      secondaryBackground: Card(
                        color: Theme.of(context).colorScheme.errorContainer,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Icon(Icons.delete,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onErrorContainer),
                          ),
                        ),
                      ),
                      key: ValueKey(snapshot.data!.docs[index].id),
                      background: Card(
                          color: Theme.of(context).colorScheme.errorContainer),
                      direction: DismissDirection.endToStart,
                      child: HomeworkTile(isTeacher: true, refresh: refresh),
                    ),
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
