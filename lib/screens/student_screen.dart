import 'package:flutter/material.dart';
import 'package:homework_app/models/homeworks.dart';
import 'package:homework_app/widgets/home/dropdown_chip.dart';
import 'package:homework_app/widgets/home/home_app_bar.dart';
import 'package:provider/provider.dart';

import '../models/student.dart';
import '../models/user.dart';
import '../widgets/home/homework_tile.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({Key? key}) : super(key: key);

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  late final Student user;
  bool _submittedSelected = false;
  bool _dateSelected = false;
  bool _subjectSelected = false;
  bool _scoredSelected = false;

  @override
  void initState() {
    super.initState();
    user = Provider.of<User>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final homeworkList = Provider.of<Homeworks>(context).homeworks.where((element) => element.className == user.class_).toList();
    return Scaffold(
      appBar: const HomeAppBar(title: 'Úlohy'),
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
                  DropdownFilterChip<String>(
                      label: const Text('Predmet'),
                      items: const [DropdownMenuItem(child: Text('yo'))],
                      onChanged: (_) {}),
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
                    avatar: _dateSelected
                        ? null
                        : Icon(
                            Icons.today,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    onPressed: !_dateSelected
                        ? () async {
                            await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now()
                                  .subtract(const Duration(days: 365)),
                              lastDate:
                                  DateTime.now().add(const Duration(days: 365)),
                            );
                            setState(
                              () => _dateSelected = true,
                            );
                          }
                        : () => setState(() => _dateSelected = false),
                    selected: _dateSelected,
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
              child: ListView.builder(
                itemBuilder: (context, index) => ChangeNotifierProvider.value(
                    value: homeworkList[index],
                    child: const HomeworkTile()),
                itemCount: homeworkList.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
