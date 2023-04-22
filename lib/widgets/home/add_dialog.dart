import 'package:flutter/material.dart';
import 'package:homework_app/widgets/home/dropdown_chip.dart';

class AddDialog extends StatefulWidget {
  const AddDialog({Key? key}) : super(key: key);

  @override
  State<AddDialog> createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _title = '';
  String _description = '';

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
      // await Provider.of<Homeworks>(context, listen: false)
      //     .addHomework(_title, _description);
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Nová úloha'),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.today),
          ),
        ],
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Názov je povinný';
                }
                return null;
              },
              onSaved: (value) => _title = value!,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Názov',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Popis je povinný';
                }
                return null;
              },
              onSaved: (value) => _description = value!,
              textInputAction: TextInputAction.newline,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Popis',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownFilterChip(
                    label: Text('Predmet'),
                    items: const [DropdownMenuItem(child: Text('yo'))],
                    onChanged: (_) {}),
                DropdownFilterChip(
                  label: const Text('Trieda'),
                  items: const [DropdownMenuItem(child: Text('yo'))],
                  onChanged: (_) {},
                  dropdownWidth: 90,
                  dropdownOffset: const Offset(-73, 0),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.attach_file)),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Zrušiť'),
        ),
        TextButton(
          onPressed: () async => await _trySubmit(),
          child: _isLoading ? const CircularProgressIndicator() : const Text('Zadať'),
        ),
      ],
    );
  }
}
