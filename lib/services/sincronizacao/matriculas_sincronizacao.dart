import 'package:cloud_firestore/cloud_firestore.dart';
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
