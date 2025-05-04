import 'package:cloud_firestore/cloud_firestore.dart';
import '../../databases/matriculas_dao.dart';
import '../../models/matricula_model.dart';

class MatriculasSincronizacao {
  static final _matriculaDao = MatriculaDao();

  static Future<void> sincronizar(String cpfProfessor) async {
    print("🔄 Iniciando sincronização bidirecional de matrículas...");

    try {
      final docRef = FirebaseFirestore.instance
          .collection('aulasministradas')
          .doc(cpfProfessor);

      final docSnap = await docRef.get();
      final Map<String, dynamic> dadosFirebase = docSnap.data() ?? {};
      final Map<String, dynamic> alunosFirebase =
          dadosFirebase['alunos'] != null
              ? Map<String, dynamic>.from(dadosFirebase['alunos'])
              : {};

      final List<MatriculaModel> matriculasLocais =
          await _matriculaDao.getTodasMatriculas();

      final Map<String, dynamic> novosDadosParaFirebase = {'alunos': {}};

      await _sincronizarFirebaseParaLocal(alunosFirebase);
      await _sincronizarLocalParaFirebase(
        matriculasLocais,
        alunosFirebase,
        novosDadosParaFirebase,
      );

      await _enviarParaFirebase(docRef, novosDadosParaFirebase);
      await _marcarMatriculasComoSincronizadas(matriculasLocais);

      print('🎯 Sincronização completa com sucesso!');
    } catch (e) {
      print('❌ Erro na sincronização: $e');
    }
  }

  /// 🔽 Importa dados do Firebase para o SQLite
  static Future<void> _sincronizarFirebaseParaLocal(
    Map<String, dynamic> alunosFirebase,
  ) async {
    for (final entry in alunosFirebase.entries) {
      final String alunoId = entry.key;
      final dynamic alunoData = entry.value;

      if (alunoData is Map && alunoData.containsKey('id_estudo')) {
        final int idEstudo = alunoData['id_estudo'];
        final String dataMatricula =
            alunoData['data_matricula'] ?? DateTime.now().toIso8601String();

        final bool existeLocal = await _matriculaDao.existsMatricula(
          alunoId,
          idEstudo,
        );

        if (!existeLocal) {
          final novaMatricula = MatriculaModel(
            idUsuario: alunoId,
            idEstudoBiblico: idEstudo,
            dataMatricula: dataMatricula,
            sincronizado: 1,
          );
          await _matriculaDao.insertMatricula(novaMatricula);
          print('📥 Firebase ➜ Local: aluno=$alunoId, estudo=$idEstudo');
        }
      } else {
        print('⚠️ Dados incompletos para aluno=$alunoId');
      }
    }
  }

  /// 🔼 Exporta dados do SQLite para o Firebase
  static Future<void> _sincronizarLocalParaFirebase(
    List<MatriculaModel> matriculasLocais,
    Map<String, dynamic> alunosFirebase,
    Map<String, dynamic> novosDadosParaFirebase,
  ) async {
    for (final matricula in matriculasLocais) {
      final String alunoId = matricula.idUsuario;
      final int idEstudo = matricula.idEstudoBiblico;

      final dadosRemotosAluno = alunosFirebase[alunoId];

      final bool jaExisteNoFirebase =
          dadosRemotosAluno is Map &&
          dadosRemotosAluno.containsKey('id_estudo') &&
          dadosRemotosAluno['id_estudo'] == idEstudo;

      if (!jaExisteNoFirebase) {
        (novosDadosParaFirebase['alunos'] as Map)[alunoId] = {
          'id_estudo': idEstudo,
          'data_matricula': matricula.dataMatricula,
          'sincronizado': 1,
        };
        print('📤 Local ➜ Firebase: aluno=$alunoId, estudo=$idEstudo');
      }
    }
  }

  /// ⬆️ Envia dados atualizados para o Firebase
  static Future<void> _enviarParaFirebase(
    DocumentReference docRef,
    Map<String, dynamic> novosDadosParaFirebase,
  ) async {
    if ((novosDadosParaFirebase['alunos'] as Map).isNotEmpty) {
      await docRef.set(novosDadosParaFirebase, SetOptions(merge: true));
      print('✅ Matrículas locais enviadas ao Firebase.');
    } else {
      print('✔️ Nenhuma matrícula local nova para o Firebase.');
    }
  }

  /// ✅ Atualiza flag de sincronização local
  static Future<void> _marcarMatriculasComoSincronizadas(
    List<MatriculaModel> matriculas,
  ) async {
    for (final matricula in matriculas) {
      await _matriculaDao.atualizarSincronizacao(matricula.id!);
    }
  }
}





/* import 'package:cloud_firestore/cloud_firestore.dart';
import '../../databases/matriculas_dao.dart';
import '../../models/matricula_model.dart';

class MatriculasSincronizacao {
  static final _matriculaDao = MatriculaDao();

  static Future<void> sincronizar(String cpfProfessor) async {
    print("📘 Iniciando sincronização de matrículas...");

    try {
      final docSnap =
          await FirebaseFirestore.instance
              .collection('aulasministradas')
              .doc(cpfProfessor)
              .get();

      if (!docSnap.exists) {
        print('❌ Documento não encontrado para o CPF: $cpfProfessor');
        return;
      }

      final data = docSnap.data();
      if (data == null || !data.containsKey('alunos')) {
        print('⚠️ Campo "alunos" não encontrado no documento.');
        return;
      }

      // Agora alunos está como um Map agrupado
      final Map<String, dynamic> alunos = Map<String, dynamic>.from(
        data['alunos'],
      );
      print('📦 ${alunos.length} alunos encontrados.');

      for (final entry in alunos.entries) {
        final String alunoId = entry.key;
        final dynamic alunoData = entry.value;

        if (alunoData is Map && alunoData.containsKey('id_estudo')) {
          final int idEstudo = alunoData['id_estudo'];

          final existe = await _matriculaDao.existsMatricula(alunoId, idEstudo);
          if (existe) {
            print(
              '🔁 Matrícula já existente: aluno=$alunoId, estudo=$idEstudo',
            );
            continue;
          }

          final novaMatricula = MatriculaModel(
            idUsuario: alunoId,
            idEstudoBiblico: idEstudo,
            dataMatricula: DateTime.now().toIso8601String(),
            sincronizado: 1,
          );

          await _matriculaDao.insertMatricula(novaMatricula);
          print('📥 Matrícula inserida: aluno=$alunoId, estudo=$idEstudo');
        } else {
          print('⚠️ Dados incompletos para aluno=$alunoId');
        }
      }

      print('🎓 Matrículas sincronizadas com sucesso.');
    } catch (e) {
      print('❌ Erro ao sincronizar matrículas: $e');
    }
  }
}
 */