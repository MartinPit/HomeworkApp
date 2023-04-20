import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PasswordResetDialog extends StatefulWidget {
  const PasswordResetDialog({Key? key}) : super(key: key);

  @override
  State<PasswordResetDialog> createState() => _PasswordResetDialogState();
}

class _PasswordResetDialogState extends State<PasswordResetDialog> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  String _password = '';
  bool _isLoading = false;

  Future<void> _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await FirebaseAuth.instance.currentUser!.updatePassword(_password);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message ?? 'Nastala chyba'),
        behavior: SnackBarBehavior.floating,
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Zmena hesla'),
      content: Form(
        key: _formKey,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  label: Text('Staré heslo'),
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                controller: _controller,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Nové heslo'),
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
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
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _trySubmit(),
              ),
            ],
          ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Zrušiť'),
        ),
        TextButton(
          onPressed: () async {
            await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(EmailAuthProvider.credential(email: FirebaseAuth.instance.currentUser!.email!, password: _controller.text));
            await _trySubmit();
          },
          child: _isLoading
              ? const CircularProgressIndicator()
              : const Text('Zmeniť'),
        ),
      ],
    );
  }
}
