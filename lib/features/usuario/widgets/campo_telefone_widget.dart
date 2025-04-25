import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/masks.dart';

class CampoTelefoneWidget extends StatelessWidget {
  final TextEditingController controller;
  final bool showErrors;

  const CampoTelefoneWidget({
    super.key,
    required this.controller,
    required this.showErrors,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(labelText: 'Telefone'),
      keyboardType: TextInputType.phone,
      inputFormatters: [telefoneFormatter],
      validator: (value) {
        if (!showErrors) return null;
        if (value == null || value.isEmpty) return 'Informe o telefone';
        if (!telefoneFormatter.isFill()) return 'Telefone incompleto';
        return null;
      },
    );
  }
}
