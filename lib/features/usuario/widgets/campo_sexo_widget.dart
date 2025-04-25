import 'package:flutter/material.dart';

class CampoSexoWidget extends StatelessWidget {
  final String? selectedSexo;
  final ValueChanged<String?> onChanged;

  const CampoSexoWidget({
    super.key,
    required this.selectedSexo,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 16),
          child: Text('Sexo:'),
        ),
        Expanded(
          child: Row(
            children: [
              Radio<String>(
                value: 'Masculino',
                groupValue: selectedSexo,
                onChanged: onChanged,
              ),
              const Text('Masculino'),
              const SizedBox(width: 20),
              Radio<String>(
                value: 'Feminino',
                groupValue: selectedSexo,
                onChanged: onChanged,
              ),
              const Text('Feminino'),
            ],
          ),
        ),
      ],
    );
  }
}
