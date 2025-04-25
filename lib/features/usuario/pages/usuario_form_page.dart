import 'package:flutter/material.dart';
import '../usuario_form_widget.dart';
import '../../../models/usuario_model.dart';

class UsuarioFormPage extends StatelessWidget {
  const UsuarioFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Conta'),
        backgroundColor: const Color(0xFF0B1121),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: UsuarioFormWidget(
          onSubmit: (Usuario usuario) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Usuário criado com sucesso')),
            );
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
