import 'package:flutter/material.dart';
import 'package:homework_app/widgets/home/dropdown_chip.dart';
import 'package:homework_app/widgets/home/home_app_bar.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({Key? key}) : super(key: key);

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  late final User user;
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
                    avatar: _dateSelected ? null : const Icon(Icons.today),
                    onPressed: !_dateSelected ? () async {
                      await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate:
                            DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      setState(
                        () => _dateSelected = true,
                      );
                    } : () => setState(() => _dateSelected = false),
                    selected: _dateSelected,
                  ),
                  const SizedBox(width: 7),
                  FilterChip(label: const Text('Ohodnotené'), onSelected: (_) => setState(() => _scoredSelected = !_scoredSelected), selected: _scoredSelected),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
