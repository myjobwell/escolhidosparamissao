import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/masks.dart';

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
      decoration: const InputDecoration(labelText: 'Data de Nascimento'),
      keyboardType: TextInputType.datetime,
      inputFormatters: [dataNascimentoFormatter],
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
