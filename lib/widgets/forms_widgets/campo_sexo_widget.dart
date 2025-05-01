import 'package:flutter/material.dart';

class CampoSexoWidget extends StatelessWidget {
  final String? selectedSexo;
  final ValueChanged<String?> onChanged;
  final bool showErrors;

  const CampoSexoWidget({
    super.key,
    required this.selectedSexo,
    required this.onChanged,
    required this.showErrors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //const Text('Sexo'),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Masculino'),
                value: 'Masculino',
                groupValue: selectedSexo,
                onChanged: onChanged,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Feminino'),
                value: 'Feminino',
                groupValue: selectedSexo,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
        if (showErrors && selectedSexo == null)
          const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(
              'Selecione o sexo',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
