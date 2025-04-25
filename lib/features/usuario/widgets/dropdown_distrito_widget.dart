import 'package:flutter/material.dart';

class DropdownDistritoWidget extends StatelessWidget {
  final String? selectedId;
  final List<Map<String, dynamic>> distritos;
  final ValueChanged<String?> onChanged;
  final bool showErrors;

  const DropdownDistritoWidget({
    super.key,
    required this.selectedId,
    required this.distritos,
    required this.onChanged,
    required this.showErrors,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedId,
      decoration: const InputDecoration(labelText: 'Distrito'),
      items:
          distritos
              .map(
                (d) => DropdownMenuItem(
                  value: d['id'] as String,
                  child: Text(d['nome'] as String),
                ),
              )
              .toList(),
      onChanged: onChanged,
      validator: (value) {
        if (!showErrors) return null;
        if (value == null) return 'Selecione um distrito';
        return null;
      },
    );
  }
}
