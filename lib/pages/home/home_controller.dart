import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../core/global.dart';
import '../../services/firebase_usuario_service.dart';
import '../../databases/usuario_dao.dart';
import '../../databases/estudos_dao.dart';
import '../../services/sincronizacao_service.dart';
import '../loading/loading_page.dart';

class HomeController {
  static Future<void> login(BuildContext context, String cpfRaw) async {
    final String cpf = cpfRaw.replaceAll(RegExp(r'[^0-9]'), '');

    if (cpf.isEmpty || cpf.length != 11) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Informe um CPF válido')));
      return;
    }

    final connectivity = await Connectivity().checkConnectivity();
    final online = connectivity != ConnectivityResult.none;

    if (online) {
      try {
        final usuario = await FirebaseUsuarioService.buscarUsuarioPorCpf(cpf);

        if (usuario == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Usuário não cadastrado. Crie uma conta.'),
            ),
          );
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => LoadingPage(
                  onLoadComplete: () async {
                    await DbUsuario.salvarUsuario(usuario);
                    cpfLogado = cpf;
                    final local = await DbUsuario.buscarUsuarioPorCpf(
                      cpfLogado!,
                    );
                    if (local != null) {
                      nomeUsuarioGlobal = local.nome;
                      uniaoIdGlobal = local.uniaoId;
                      uniaoNomeGlobal = local.uniaoNome;
                      associacaoIdGlobal = local.associacaoId;
                      associacaoNomeGlobal = local.associacaoNome;
                      distritoIdGlobal = local.distritoId;
                      distritoNomeGlobal = local.distritoNome;
                      igrejaIdGlobal = local.igrejaId;
                      igrejaNomeGlobal = local.igrejaNome;
                    }
                    await SincronizacaoService.sincronizarTudo(cpf);
                    await DbEstudos.sincronizarEstudosComApi();
                  },
                ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao sincronizar dados online.')),
        );
      }
    } else {
      final local = await DbUsuario.buscarUsuarioPorCpf(cpf);
      if (local == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário não encontrado localmente.')),
        );
        return;
      }

      cpfLogado = cpf;
      nomeUsuarioGlobal = local.nome;
      uniaoIdGlobal = local.uniaoId;
      uniaoNomeGlobal = local.uniaoNome;
      associacaoIdGlobal = local.associacaoId;
      associacaoNomeGlobal = local.associacaoNome;
      distritoIdGlobal = local.distritoId;
      distritoNomeGlobal = local.distritoNome;
      igrejaIdGlobal = local.igrejaId;
      igrejaNomeGlobal = local.igrejaNome;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => LoadingPage(
                onLoadComplete: () async {
                  // offline fallback
                },
              ),
        ),
      );
    }
  }
}
