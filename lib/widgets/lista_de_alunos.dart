import 'package:flutter/material.dart';
import 'title_widget.dart'; // Importa o TitleWidget para listar os alunos

class ListaDeAlunos extends StatelessWidget {
  const ListaDeAlunos({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Alunos',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0B1121),
          ),
        ),
        const SizedBox(height: 15),
        const TitleWidget(
          name: 'Lucas Silva',
          progress: '15 Estudos Bíblicos',
          bgColor: Color(0xFFBBDEFB), // Azul claro
        ),
        const TitleWidget(
          name: 'Mariana Costa',
          progress: '12 Estudos Bíblicos',
          bgColor: Color(0xFFC8E6C9), // Verde claro
        ),
        const TitleWidget(
          name: 'Carlos Pereira',
          progress: '20 Estudos Bíblicos',
          bgColor: Color(0xFFD1C4E9), // Roxo claro
        ),
      ],
    );
  }
}
