import 'package:flutter/material.dart';
import '../../models/usuario_model.dart';
import '../../services/usuario_service.dart';
import '../widgets/usuario_form_widget.dart';

class UserCrudPage extends StatefulWidget {
  const UserCrudPage({super.key});

  @override
  State<UserCrudPage> createState() => _UserCrudPageState();
}

class _UserCrudPageState extends State<UserCrudPage> {
  final UsuarioService _service = UsuarioService();
  Usuario? _editing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gerenciar Usuários")),
      body: Column(
        children: [
          UsuarioFormWidget(
            usuario: _editing,
            onSubmit: (usuario) {
              if (usuario.id != null) {
                _service.atualizarUsuario(usuario);
              } else {
                _service.criarUsuario(usuario);
              }
              setState(() => _editing = null);
            },
          ),
          Expanded(
            child: StreamBuilder<List<Usuario>>(
              stream: _service.listarUsuarios(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                final usuarios = snapshot.data!;
                return ListView.builder(
                  itemCount: usuarios.length,
                  itemBuilder: (context, index) {
                    final u = usuarios[index];
                    return ListTile(
                      title: Text(u.nome),
                      subtitle: Text(u.cpf),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => setState(() => _editing = u),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _service.deletarUsuario(u.id!),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
