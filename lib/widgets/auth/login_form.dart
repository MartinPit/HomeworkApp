import 'package:flutter/material.dart';

import '../../models/person.dart';

class LoginForm extends StatefulWidget {
  final Function(String uco, String password) handler;

  const LoginForm({Key? key, required this.handler}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _form = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _isSelected = false;
  String _uco = '';
  String _password = '';
  bool _isLoading = false;

  void _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }

    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    await widget.handler(_uco, _password);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Column(
        children: [
          SizedBox(
            width: 220,
            child: TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Učo je povinné';
                }

                if (value.length > 6) {
                  return 'Učo je príliš dlhé';
                }

                try{
                  int.parse(value);
                } on FormatException {
                  return 'Učo musí byť celé číslo';
                }
                return null;
              },
              onSaved: (value) {
                _uco = value!;
              },
              keyboardType: TextInputType.number,
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
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Heslo je povinné';
                }
                if (value.length < 6) {
                  return 'Heslo je príliš krátke';
                }
                return null;
              },
              onSaved: (value) {
                _password = value!;
              },
              keyboardType: !_obscureText ? TextInputType.visiblePassword : TextInputType.text,
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
          if (_isLoading)
            const CircularProgressIndicator()
          else
            FilledButton(
              onPressed: _saveForm,
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
