import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/masks.dart';

class CampoDataNascimentoWidget extends StatelessWidget {
  final TextEditingController controller;
  final bool showErrors;

  const CampoDataNascimentoWidget({
    super.key,
    required this.controller,
    required this.showErrors,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.datetime,
      inputFormatters: [dataNascimentoFormatter],
      decoration: InputDecoration(
        labelText: 'Data de Nascimento',
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
      validator: (value) {
        if (!showErrors) return null;
        if (value == null || value.isEmpty)
          return 'Informe a data de nascimento';
        if (!RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(value))
          return 'Formato inválido';
        return null;
      },
    );
  }
}
