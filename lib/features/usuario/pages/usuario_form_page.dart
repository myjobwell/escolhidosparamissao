import 'package:flutter/material.dart';
import '../usuario_form_widget.dart';
import '../../professor/page_professor.dart'; // ✅ Import da PageProfessor

class UsuarioFormPage extends StatelessWidget {
  const UsuarioFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF2FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEFF2FB),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0B1121)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Criar conta',
          style: TextStyle(
            color: Color(0xFF0B1121),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: UsuarioFormWidget(
          onComplete: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Usuário criado com sucesso')),
            );
            // ✅ Ao invés de voltar, agora navega para PageProfessor
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const PageProfessor()),
            );
          },
        ),
      ),
    );
  }
}
