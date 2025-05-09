import 'package:cloud_firestore/cloud_firestore.dart';
import '../../databases/usuario_dao.dart';
import '../../models/usuario_model.dart';

class AlunosSincronizacao {
  static Future<void> sincronizar(String cpfProfessor) async {
    print("📚 Iniciando sincronização de alunos do professor...");
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('usuarios')
              .where('id_professor', isEqualTo: cpfProfessor)
              .get();

      print('📦 ${snapshot.docs.length} alunos encontrados no Firebase.');

      List<String> alunosJaExistem = [];
      List<String> alunosSincronizados = [];
      List<String> alunosIgnorados = [];

      final tarefas =
          snapshot.docs.map((doc) async {
            final data = doc.data();
            final String idDocumento = doc.id;
            final String? cpfFirebase = data['cpf'];

            if (cpfFirebase != null) {
              final Usuario? alunoLocal = await DbUsuario.buscarUsuarioPorCpf(
                cpfFirebase,
              );
              if (alunoLocal == null) {
                final novoAluno = Usuario.fromMap(data, idDocumento);
                await DbUsuario.salvarUsuario(novoAluno);
                alunosSincronizados.add(novoAluno.nome);
                print('✅ Aluno ${novoAluno.nome} salvo localmente.');
              } else {
                alunosJaExistem.add(alunoLocal.nome);
              }
            } else {
              alunosIgnorados.add(idDocumento);
              print('⚠️ Documento "$idDocumento" ignorado: CPF ausente.');
            }
          }).toList();

      await Future.wait(tarefas);

      if (alunosJaExistem.isNotEmpty) {
        print(
          'ℹ️ Alunos que já existiam localmente (${alunosJaExistem.length}):',
        );
        alunosJaExistem.asMap().forEach((index, nome) {
          print('   ${index + 1}. $nome');
        });
      }

      if (alunosSincronizados.isNotEmpty) {
        print(
          '🔄 Alunos sincronizados do Firebase (${alunosSincronizados.length}):',
        );
        alunosSincronizados.asMap().forEach((index, nome) {
          print('   ${index + 1}. $nome');
        });
      }

      if (alunosIgnorados.isNotEmpty) {
        print(
          '⚠️ Documentos ignorados por ausência de CPF (${alunosIgnorados.length}):',
        );
        alunosIgnorados.asMap().forEach((index, docId) {
          print('   ${index + 1}. Documento ID: $docId');
        });
      }

      print('✅ Sincronização de alunos concluída com sucesso.');
    } catch (e) {
      print('❌ Erro ao sincronizar alunos do professor: $e');
    }
  }
}
