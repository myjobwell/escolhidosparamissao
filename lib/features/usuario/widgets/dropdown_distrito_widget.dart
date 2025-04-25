import 'package:flutter/material.dart';

class DropdownDistritoWidget extends StatelessWidget {
  final String? selectedId;
  final List<Map<String, dynamic>> distritos;
  final ValueChanged<String?> onChanged;

  const DropdownDistritoWidget({
    super.key,
    required this.selectedId,
    required this.distritos,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedId,
      decoration: const InputDecoration(labelText: 'Distrito'),
      items:
          distritos.map((distrito) {
            return DropdownMenuItem<String>(
              value: distrito['id'],
              child: Text(distrito['nome']),
            );
          }).toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Selecione um distrito' : null,
    );
  }
}
