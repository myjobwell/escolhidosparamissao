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
        print('❌ Documento não encontrado.');
        return;
      }

      final data = docSnap.data();
      if (data == null || !data.containsKey('alunos')) {
        print('⚠️ Nenhum dado de alunos encontrado.');
        return;
      }

      final Map<String, dynamic> alunos = data['alunos'];
      print('📦 ${alunos.length} matrículas encontradas para sincronizar.');

      for (final entry in alunos.entries) {
        final String alunoId = entry.key;
        final alunoData = entry.value;

        if (alunoData is Map && alunoData.containsKey('aulas_ministradas')) {
          final List aulas = alunoData['aulas_ministradas'];
          for (final aula in aulas) {
            if (aula is Map && aula.containsKey('id_estudo')) {
              final novaMatricula = MatriculaModel(
                idUsuario: alunoId,
                idEstudoBiblico: aula['id_estudo'],
                dataMatricula:
                    aula['data_matricula'] ?? DateTime.now().toIso8601String(),
                sincronizado: 1,
              );
              await _matriculaDao.insertMatricula(novaMatricula);
              print(
                '📥 Matrícula inserida: aluno=$alunoId, estudo=${aula['id_estudo']}',
              );
            }
          }
        }
      }

      print('🎓 Matrículas sincronizadas com sucesso.');
    } catch (e) {
      print('❌ Erro ao sincronizar matrículas: $e');
    }
  }
}
