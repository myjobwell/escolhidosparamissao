import 'package:cloud_firestore/cloud_firestore.dart';
import '../../databases/licoes_dadas_dao.dart';
import '../../models/licoes_dadas_model.dart';

class LicoesSincronizacao {
  static final _licDao = LicoesDadasDao();
  static final _firestore = FirebaseFirestore.instance;

  /// 🔁 Firebase ➜ Local
  static Future<void> sincronizarFirebaseParaLocal(String cpfProfessor) async {
    print("⬇️ Sincronizando lições do Firebase para o banco local...");
    final docRef = _firestore.collection('aulasministradas').doc(cpfProfessor);
    final snapshot = await docRef.get();

    if (!snapshot.exists) {
      print('⚠️ Nenhum dado no Firebase para o professor $cpfProfessor.');
      return;
    }

    final data = snapshot.data() ?? {};
    final alunos = data['alunos'] as Map<String, dynamic>? ?? {};

    for (final entry in alunos.entries) {
      final alunoId = entry.key;
      final alunoData = entry.value as Map<String, dynamic>;
      final estudo = alunoData['id_estudo'] as Map<String, dynamic>? ?? {};
      final idEstudo = estudo['id'] as int?;
      final licoes = estudo['licoes_dadas'] as List<dynamic>? ?? [];

      if (idEstudo == null) continue;

      for (final l in licoes) {
        final idLicao = l['idLicao'] as int?;
        final checado = l['checado'] as bool?;
        final idProfessor = l['id_professor'] as String?;
        final dataUpdate = l['data_update'] as String?;

        if (idLicao == null || checado == null) continue;

        final existente = await _licDao.buscarPorUsuarioEstudoLicao(
          alunoId,
          idEstudo,
          idLicao,
        );

        final novaLicao = LicoesDadas(
          id: existente?.id,
          idUsuario: alunoId,
          idEstudoBiblico: idEstudo,
          idLicao: idLicao,
          checado: checado,
          sincronizado: 1,
          idProfessor: idProfessor,
          dataUpdate: dataUpdate,
        );

        if (existente == null) {
          await _licDao.salvar(novaLicao);
          print('✅ Lição $idLicao do aluno $alunoId inserida localmente.');
        } else {
          await _licDao.atualizar(novaLicao);
          print('🔁 Lição $idLicao do aluno $alunoId atualizada localmente.');
        }
      }
    }

    print('✅ Lição sincronizada do Firebase para o banco local.');
  }

  /// 🔁 Local ➜ Firebase
  static Future<void> sincronizarLocalParaFirebase(String cpfProfessor) async {
    print("⬆️ Sincronizando lições do banco local para o Firebase...");
    final licoesPendentes = await _licDao.buscarLicoesNaoSincronizadas();

    for (final licao in licoesPendentes) {
      final docRef = _firestore
          .collection('aulasministradas')
          .doc(cpfProfessor);
      final snapshot = await docRef.get();
      final data = snapshot.data() ?? {};
      final alunos = data['alunos'] as Map<String, dynamic>? ?? {};
      final alunoData = alunos[licao.idUsuario] as Map<String, dynamic>? ?? {};
      final estudo = alunoData['id_estudo'] as Map<String, dynamic>? ?? {};

      final List<dynamic> licoes = estudo['licoes_dadas'] ?? [];

      final index = licoes.indexWhere(
        (item) => item['idLicao'] == licao.idLicao,
      );

      final novaLicao = {
        'idLicao': licao.idLicao,
        'checado': licao.checado,
        'sincronizado': 1,
        'id_professor': licao.idProfessor ?? cpfProfessor,
        'data_update': licao.dataUpdate ?? DateTime.now().toIso8601String(),
      };

      if (index >= 0) {
        licoes[index] = novaLicao;
      } else {
        licoes.add(novaLicao);
      }

      final payload = {
        'id_estudo': {
          'id': licao.idEstudoBiblico,
          'data_matricula': estudo['data_matricula'] ?? '',
          'licoes_dadas': licoes,
        },
      };

      await docRef.set({
        'alunos': {licao.idUsuario: payload},
      }, SetOptions(merge: true));

      await _licDao.atualizarSincronizacao(licao.id!);
      print(
        '✅ Lição ${licao.idLicao} do aluno ${licao.idUsuario} sincronizada com o Firebase.',
      );
    }

    print(
      '✅ Sincronização de lições do banco local para o Firebase concluída.',
    );
  }

  /// 🔁 Bidirecional
  static Future<void> sincronizar(String cpfProfessor) async {
    await sincronizarFirebaseParaLocal(cpfProfessor);
    await sincronizarLocalParaFirebase(cpfProfessor);
  }
}
