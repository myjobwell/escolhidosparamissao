import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/masks.dart';

class CampoDataNascimentoWidget extends StatelessWidget {
  final TextEditingController controller;

  const CampoDataNascimentoWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Data de Nascimento (dd/MM/yyyy)',
      ),
      inputFormatters: [dataNascimentoFormatter],
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty || value.length != 10) {
          return 'Informe a data no formato correto';
        }
        final partes = value.split('/');
        if (partes.length != 3) return 'Data inválida';
        final dia = int.tryParse(partes[0]);
        final mes = int.tryParse(partes[1]);
        final ano = int.tryParse(partes[2]);
        if (dia == null || mes == null || ano == null) return 'Data inválida';
        return null;
      },
    );
  }
}
