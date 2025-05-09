import 'package:flutter/material.dart';
import 'package:mipsmais/pages/usuario/usuario_form.dart';
import '../professor/home_painel_screen.dart';
import '../../databases/usuario_dao.dart';
import '../../databases/estudos_dao.dart';
import '../../services/sincronizacao_service.dart';
import '../../core/global.dart';

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
          onComplete: (String cpf) async {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Usuário criado com sucesso')),
            );

            final usuario = await DbUsuario.buscarUsuarioPorCpf(cpf);
            if (usuario != null) {
              cpfLogado = usuario.cpf;
              nomeUsuarioGlobal = usuario.nome;
              uniaoIdGlobal = usuario.uniaoId;
              uniaoNomeGlobal = usuario.uniaoNome;
              associacaoIdGlobal = usuario.associacaoId;
              associacaoNomeGlobal = usuario.associacaoNome;
              distritoIdGlobal = usuario.distritoId;
              distritoNomeGlobal = usuario.distritoNome;
              igrejaIdGlobal = usuario.igrejaId;
              igrejaNomeGlobal = usuario.igrejaNome;

              await SincronizacaoService.sincronizarTudo();
              await DbEstudos.sincronizarEstudosComApi();
            }

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePainel()),
            );
          },
        ),
      ),
    );
  }
}
