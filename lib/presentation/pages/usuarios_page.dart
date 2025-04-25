import 'package:flutter/material.dart';
import '../../models/usuario_model.dart';
import '../../services/usuario_service.dart';
import '../../features/usuario/usuario_form_widget.dart';

class UserCrudPage extends StatelessWidget {
  const UserCrudPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UsuarioService _service = UsuarioService();

    return Scaffold(
      appBar: AppBar(title: const Text("Cadastro de Usuário")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: UsuarioFormWidget(
          onSubmit: (usuario) {
            _service.criarUsuario(usuario);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Usuário cadastrado com sucesso')),
            );
          },
        ),
      ),
    );
  }
}
