import 'package:flutter/material.dart';

class DropdownIgrejaWidget extends StatelessWidget {
  final String? selectedId;
  final List<Map<String, dynamic>> igrejas;
  final ValueChanged<String?> onChanged;
  final bool showErrors;

  const DropdownIgrejaWidget({
    super.key,
    required this.selectedId,
    required this.igrejas,
    required this.onChanged,
    required this.showErrors,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedId,
      decoration: const InputDecoration(labelText: 'Igreja'),
      items:
          igrejas
              .map(
                (i) => DropdownMenuItem(
                  value: i['id'] as String,
                  child: Text(i['nome'] as String),
                ),
              )
              .toList(),
      onChanged: onChanged,
      validator: (value) {
        if (!showErrors) return null;
        if (value == null) return 'Selecione uma igreja';
        return null;
      },
    );
  }
}
