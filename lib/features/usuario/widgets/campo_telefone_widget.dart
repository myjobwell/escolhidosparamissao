import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CampoTelefoneWidget extends StatelessWidget {
  final TextEditingController controller;

  const CampoTelefoneWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(labelText: 'Telefone'),
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(11),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) return 'Informe o telefone';
        if (value.length < 10 || value.length > 11) return 'Telefone inválido';
        return null;
      },
    );
  }
}
