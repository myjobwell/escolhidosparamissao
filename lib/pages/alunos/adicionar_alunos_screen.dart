import 'package:flutter/material.dart';
import '../../widgets/layout_page.dart';

class AdicionarAlunoPage extends StatelessWidget {
  const AdicionarAlunoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      titulo: 'Adicionar Aluno',
      isLoading: false,
      child: const Center(
        child: Text('Tela de Adição de Aluno', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
