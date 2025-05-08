import 'package:cloud_firestore/cloud_firestore.dart';
import '../../databases/matriculas_dao.dart';
import '../../databases/licoes_dadas_dao.dart';
import '../../models/matricula_model.dart';
import '../../models/licoes_dadas_model.dart';
import '../../core/global.dart'; // Supondo que cpfLogado esteja aqui

class MatriculasSincronizacao {
  static final _matDao = MatriculaDao();
  static final _licDao = LicoesDadasDao();
  static final _firestore = FirebaseFirestore.instance;

  /// Inicia a sincronização bidirecional
  static Future<void> sincronizar(String cpfProfessor) async {
    print("🔄 Iniciando sincronização bidirecional...");

    final docRefLeitura = _firestore
        .collection('aulasministradas')
        .doc(cpfProfessor);
    final docRefEscrita = _firestore
        .collection('aulasministradas')
        .doc(cpfLogado);

    // ─── 1️⃣ Firebase ➜ Local ─────────────────────────────────────────────
    final snap = await docRefLeitura.get();
    final data = snap.data() ?? {};
    final alunosFs = (data['alunos'] as Map<String, dynamic>?) ?? {};

    for (final entry in alunosFs.entries) {
      final alunoId = entry.key;
      final alunoMap = entry.value as Map<String, dynamic>;
      final estudoMap = alunoMap['id_estudo'] as Map<String, dynamic>;

      // Matrícula
      final int idEstudo = estudoMap['id'] as int;
      final String dataMat = estudoMap['data_matricula'] as String;
      if (!await _matDao.existsMatricula(alunoId, idEstudo)) {
        await _matDao.insertMatricula(
          MatriculaModel(
            idUsuario: alunoId,
            idEstudoBiblico: idEstudo,
            dataMatricula: dataMat,
            sincronizado: 1,
          ),
        );
      }

      // Lições
      final licoes =
          (estudoMap['licoes_dadas'] as List<dynamic>?)
              ?.cast<Map<String, dynamic>>() ??
          [];
      for (final l in licoes) {
        final remoto = await _licDao.buscarPorUsuarioEstudoLicao(
          alunoId,
          idEstudo,
          l['idLicao'] as int,
        );
        final model = LicoesDadas(
          id: null,
          idUsuario: alunoId,
          idEstudoBiblico: idEstudo,
          idLicao: l['idLicao'] as int,
          checado: l['checado'] as bool, // ← agora passa bool
          sincronizado: 1,
        );
        if (remoto == null) {
          await _licDao.salvar(model);
        } else {
          await _licDao.atualizar(model.copyWith(id: remoto.id));
        }
      }
    }

    // ─── 2️⃣ Local ➜ Firebase (paginação + batch writes) ─────────────────
    const int pageSize = 100;
    int offset = 0;
    List<MatriculaModel> pagina;

    do {
      pagina = await _matDao.buscarMatriculasNaoSincronizadasPaginadas(
        limit: pageSize,
        offset: offset,
      );
      if (pagina.isEmpty) break;

      final batch = _firestore.batch();
      for (final m in pagina) {
        final pendentes = await _licDao.buscarLicoesPendentesPorEstudo(
          m.idEstudoBiblico,
        );

        final payload = {
          'id_estudo': {
            'id': m.idEstudoBiblico,
            'data_matricula': m.dataMatricula,
            'licoes_dadas':
                pendentes
                    .map(
                      (l) => {
                        'idLicao': l.idLicao,
                        'checado': l.checado, // ← já é bool
                        'sincronizado': 1,
                      },
                    )
                    .toList(),
          },
        };

        batch.set(docRefEscrita, {
          'alunos': {m.idUsuario: payload},
        }, SetOptions(merge: true));
      }

      // comita todas as operações de uma só vez
      await batch.commit();

      // marca localmente matrículas e lições como sincronizadas
      for (final m in pagina) {
        await _matDao.atualizarSincronizacao(m.id!);
        final pend = await _licDao.buscarLicoesPendentesPorEstudo(
          m.idEstudoBiblico,
        );
        for (final l in pend) {
          await _licDao.atualizarSincronizacao(l.id!);
        }
      }

      offset += pageSize;
    } while (pagina.length == pageSize);

    print('✅ Sincronização concluída com sucesso!');
  }
}
