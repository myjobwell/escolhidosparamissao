import 'package:flutter/material.dart';

class DropdownIgrejaWidget extends StatelessWidget {
  final String? selectedId;
  final List<Map<String, dynamic>> igrejas;
  final ValueChanged<String?> onChanged;

  const DropdownIgrejaWidget({
    super.key,
    required this.selectedId,
    required this.igrejas,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedId,
      decoration: const InputDecoration(labelText: 'Igreja'),
      items:
          igrejas.map((igreja) {
            return DropdownMenuItem<String>(
              value: igreja['id'],
              child: Text(igreja['nome']),
            );
          }).toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Selecione uma igreja' : null,
    );
  }
}
