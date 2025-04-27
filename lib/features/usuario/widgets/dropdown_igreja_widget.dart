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
      dropdownColor: Colors.white,
      style: const TextStyle(
        fontSize: 16,
        color: Color(0xFF0B1121), // estilo do item selecionado
      ),
      decoration: InputDecoration(
        labelText: 'Igreja',
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFDADCE0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF0B1121), width: 1.5),
        ),
      ),
      items:
          igrejas.map((i) {
            return DropdownMenuItem<String>(
              value: i['id'],
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  i['nome'],
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF0B1121),
                  ),
                ),
              ),
            );
          }).toList(),
      selectedItemBuilder: (context) {
        return igrejas.map((i) {
          return Text(
            i['nome'],
            style: const TextStyle(fontSize: 16, color: Color(0xFF0B1121)),
          );
        }).toList();
      },
      onChanged: onChanged,
      validator: (value) {
        if (!showErrors) return null;
        if (value == null) return 'Selecione uma igreja';
        return null;
      },
    );
  }
}
