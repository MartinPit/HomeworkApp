import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DropdownFilterChip<T> extends HookWidget {
  const DropdownFilterChip({
    Key? key,
    required this.label,
    this.value,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  final Widget label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T? value) onChanged;

  @override
  Widget build(BuildContext context) {
    final dropdownButtonKey = useMemoized(() => GlobalKey());
    final focusNode = useFocusNode();
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          label,
          const SizedBox(width: 8),
          const FaIcon(FontAwesomeIcons.caretDown, size: 12),
          Offstage(
            child: DropdownButton2<T>(
              key: dropdownButtonKey,
              focusNode: focusNode,
              value: value,
              items: items,
              onChanged: (value) {
                onChanged(value);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  focusNode.unfocus();
                });
              },
              dropdownStyleData: DropdownStyleData(
                width: 105,
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                offset: const Offset(-88, 0),
              ),
              menuItemStyleData: const MenuItemStyleData(
                padding: EdgeInsets.symmetric(horizontal: 8),
                height: 28,
              ),
            ),
          ),
        ],
      ),
      onSelected: (_) {
        dropdownButtonKey.currentContext?.visitChildElements((element) {
          if (element.widget is Semantics) {
            element.visitChildElements((element) {
              if (element.widget is Actions) {
                element.visitChildElements((element) {
                  Actions.invoke(element, const ActivateIntent());
                });
              }
            });
          }
        });
      },
    );
  }
}
