import 'package:flutter/material.dart';

class GradingScreen extends StatelessWidget {
  static const routeName = '/grading_screen';

  const GradingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Odovzdaná úloha'),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: const Center(child: Text('Grading Screen')),
    );
  }
}
