import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../models/usuario_model.dart';
import '../../services/firebase_usuario_service.dart' as core_firebase;
import '../../utils/masks.dart';
import '../../databases/usuario_dao.dart';
import '../../databases/ranking_dao.dart';
import '../../databases/app_database.dart';
import '../../core/global.dart';
import '../alunos/aluno_screen.dart';

class AdicionarAlunoController {
  final nome = TextEditingController();
  final dataNascimento = TextEditingController();
  final telefone = TextEditingController();

  String? sexo;
  bool formFoiEnviado = false;
  bool isSaving = false;

  void init() {}

  void dispose() {
    nome.dispose();
    dataNascimento.dispose();
    telefone.dispose();
  }

  bool _isFormValido() {
    return nome.text.isNotEmpty && sexo != null;
  }

  String _converterDataParaIso(String dataBr) {
    try {
      final partes = dataBr.split('/');
      final dia = int.parse(partes[0]);
      final mes = int.parse(partes[1]);
      final ano = int.parse(partes[2]);
      return DateTime(ano, mes, dia).toIso8601String();
    } catch (_) {
      return '';
    }
  }

  Future<void> cadastrarUsuario(
    BuildContext context,
    GlobalKey<FormState> formKey,
  ) async {
    if (isSaving) return;

    formFoiEnviado = true;
    isSaving = true;

    if (!formKey.currentState!.validate() || !_isFormValido()) {
      isSaving = false;
      return;
    }

    final nascimento = dataNascimento.text;
    final uuid = const Uuid();
    final String idFinal = uuid.v4();

    if (idFinal.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro: ID gerado está vazio.')),
      );
      isSaving = false;
      return;
    }

    final usuario = Usuario(
      id: idFinal,
      nome: nome.text,
      cpf: "",
      nascimento: nascimento,
      sexo: sexo ?? '',
      telefone: telefoneFormatter.getUnmaskedText(),
      email: '',
      tipoUsuario: 'Aluno',
      divisaoId: 1,
      divisaoNome: 'Divisão Sul Americana (DSA)',
      uniaoId: uniaoIdGlobal!,
      uniaoNome: uniaoNomeGlobal!,
      associacaoId: associacaoIdGlobal!,
      associacaoNome: associacaoNomeGlobal!,
      distritoId: distritoIdGlobal!,
      distritoNome: distritoNomeGlobal!,
      igrejaId: igrejaIdGlobal!,
      igrejaNome: igrejaNomeGlobal!,
      sincronizado: false,
      idProfessor: cpfLogado,
    );

    bool erroGrave = false;
    bool online = false;

    try {
      // 1. Salvar localmente
      await DbUsuario.salvarUsuario(usuario);

      // 2. Atualizar ranking local
      final db = await AppDatabase.getDatabase();
      final rankingDao = RankingDao(db);

      // ✅ Sincronizar apenas se estiver online
      try {
        final result = await Connectivity().checkConnectivity();
        online = result != ConnectivityResult.none;
      } catch (e) {
        debugPrint("❌ Falha ao verificar conectividade: $e");
      }

      await rankingDao.registrarCadastroAluno(
        id: cpfLogado!,
        nome: nomeUsuarioGlobal!,
        sexo: sexo!,
        distritoNome: distritoNomeGlobal!,
        igrejaNome: igrejaNomeGlobal!,
        sincronizar: online,
      );

      // 3. Tentar sincronizar com Firebase se online
      if (online) {
        try {
          final sucesso = await core_firebase
              .FirebaseUsuarioService.salvarUsuario(usuario);
          if (sucesso) {
            await FirebaseFirestore.instance
                .collection('usuarios')
                .doc(usuario.id)
                .update({'sincronizado': 1});

            await DbUsuario.atualizarSincronizacao(usuario.id);
          }
        } catch (e) {
          debugPrint('⚠️ Erro ao sincronizar com Firebase: $e');
        }
      } else {
        debugPrint('📴 Offline. Cadastro salvo localmente.');
      }
    } catch (e) {
      erroGrave = true;
      debugPrint('❌ Erro ao cadastrar aluno: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Erro ao cadastrar aluno.')));
    } finally {
      isSaving = false;

      if (!erroGrave && context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AlunosPage()),
        );
      }
    }
  }
}
