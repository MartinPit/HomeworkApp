import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _obscureText = true;
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          SizedBox(
            width: 220,
            child: TextFormField(
              decoration: const InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(),
                  label: Text('Učo'),
                  prefixIcon: Icon(Icons.person_outline_outlined)),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: 220,
            child: TextFormField(
              obscureText: _obscureText,
              decoration: InputDecoration(
                isDense: true,
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                      _isSelected = !_isSelected;
                    });
                  },
                  highlightColor: Colors.transparent,
                  icon: const Icon(Icons.remove_red_eye),
                  selectedIcon: const Icon(Icons.remove_red_eye_outlined),
                  isSelected: _isSelected,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          FilledButton(
            onPressed: () {},
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(
                const Size(220, 40),
              ),
            ),
            child: const Text('Prihlásiť sa'),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Zabudnuté heslo?'),
          ),
        ],
      ),
    );
  }
}
