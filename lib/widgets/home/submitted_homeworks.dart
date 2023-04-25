import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:homework_app/models/submission.dart';
import 'package:homework_app/widgets/home/submission_tile.dart';
import 'package:provider/provider.dart';

import '../../models/classes.dart';
import '../../models/subjects.dart';
import '../../models/teacher.dart';
import '../../utils.dart';
import 'dropdown_chip.dart';

class SubmittedHomeworks extends StatefulWidget {
  const SubmittedHomeworks({Key? key}) : super(key: key);

  @override
  State<SubmittedHomeworks> createState() => _SubmittedHomeworksState();
}

class _SubmittedHomeworksState extends State<SubmittedHomeworks> {
  final _controller = TextEditingController();
  late final Teacher user;
  bool _isEmpty = true;
  bool _gradedSelected = false;
  String? _subjectFilter;
  String? _classFilter;

  @override
  void initState() {
    user = Provider.of<Teacher>(context, listen: false);
    _controller
        .addListener(() => setState(() => _isEmpty = _controller.text.isEmpty));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void refresh() {
    setState(() {});
  }

  void subjectHandler(dynamic subject) {
    setState(() => _subjectFilter =
        subject == null ? null : (subject as Subject).toEnglishString());
  }

  void classHandler(dynamic class_) {
    setState(() => _classFilter =
        class_ == null ? null : (class_ as Class).toEnglishString());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.translucent,
      child: Column(
        children: [
          SizedBox(
            height: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 230,
                  child: TextField(
                    controller: _controller,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: !_isEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () => _controller.clear(),
                            )
                          : null,
                      label: const Text('Názov úlohy'),
                      isDense: true,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
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
                        selected: _subjectFilter != null,
                        dropdownWidth: _subjectFilter != null ? 122 : 105,
                        dropdownOffset: _subjectFilter != null
                            ? const Offset(-106, 0)
                            : const Offset(-88, 0),
                      ),
                      const SizedBox(width: 7),
                      DropdownFilterChip(
                        label: const Text('Trieda'),
                        items: Utils.createClassList(user.classes),
                        onChanged: classHandler,
                        dropdownWidth: _classFilter != null ? 108 : 90,
                        dropdownOffset: _classFilter != null
                            ? const Offset(-92, 0)
                            : const Offset(-73, 0),
                        selected: _classFilter != null,
                      ),
                      const SizedBox(width: 7),
                      FilterChip(
                        label: const Text('Ohodnotené'),
                        onSelected: (_) =>
                            setState(() => _gradedSelected = !_gradedSelected),
                        selected: _gradedSelected,
                      ),
                    ],
                  ),
                ),
                // ListView(),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('submissions')
                  .where('teacherUCO', isEqualTo: user.uco)
                  .where('grade', whereIn: _gradedSelected ? ['A', 'B', 'C', 'D', 'E', 'FX'] : ['A', 'B', 'C', 'D', 'E', 'FX', ''])
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemBuilder: (context, index) => ChangeNotifierProvider(
                    create: (_) =>
                        Submission.fromDoc(snapshot.data!.docs[index]),
                    child: SubmissionTile(refresh: refresh, class_: _classFilter, subject: _subjectFilter, title: _controller.text),
                  ),
                  itemCount: snapshot.data!.docs.length,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
