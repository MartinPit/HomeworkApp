import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _resetPassword() async {
    String email = '';

    void _sendResetMail() async {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        Navigator.of(context).pop();
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message ?? 'Nastala chyba'),
          behavior: SnackBarBehavior.floating,
        ));
      }
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Prosím zadajte váš e-mail'),
        content: TextField(
          onChanged: (value) => email = value,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
              isDense: true,
              border: OutlineInputBorder(),
              label: Text('E-mail'),
              prefixIcon: Icon(Icons.email_outlined)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Zrušiť'),
          ),
          TextButton(
            onPressed: _sendResetMail,
            child: const Text('Zaslať'),
          ),
        ],
      ),
    );
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

                try {
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
              keyboardType: !_obscureText
                  ? TextInputType.visiblePassword
                  : TextInputType.text,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _saveForm(),
              decoration: InputDecoration(
                label: const Text('Heslo'),
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
            onPressed: _resetPassword,
            child: const Text('Zabudnuté heslo?'),
          ),
        ],
      ),
    );
  }
}
