import 'package:flutter/material.dart';
import 'package:homework_app/widgets/home/dropdown_chip.dart';
import 'package:provider/provider.dart';

import '../../models/homeworks.dart';
import '../../models/teacher.dart';
import 'homework_tile.dart';

class AssignedHomeworks extends StatefulWidget {
  const AssignedHomeworks({Key? key}) : super(key: key);

  @override
  State<AssignedHomeworks> createState() => _AssignedHomeworksState();
}

class _AssignedHomeworksState extends State<AssignedHomeworks> {
  late final Teacher user;

  @override
  void initState() {
    super.initState();
    user = Provider.of<Teacher>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final _homeworks = Provider.of<Homeworks>(context)
        .homeworks
        .where((element) => element.teacherUCO == user.uco)
        .toList();
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
                  items: const [DropdownMenuItem(child: Text('yup'))],
                  onChanged: (_) {}),
              const SizedBox(width: 7),
              DropdownFilterChip(
                  label: const Text('Trieda'),
                  items: const [DropdownMenuItem(child: Text('yup'))],
                  onChanged: (_) {},
                  dropdownWidth: 90, dropdownOffset: const Offset(-73, 0)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
              itemBuilder: (context, index) =>
                  ChangeNotifierProvider.value(
                      value: _homeworks[index],
                      child: const HomeworkTile(isHomework: true)),
              itemCount: _homeworks.length),
        ),
      ],
    );
  }
}
