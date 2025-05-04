import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/matricula_model.dart';
import '../models/usuario_model.dart';
import '../databases/matriculas_dao.dart';
import '../core/global.dart' as globals;

class FirebaseMatriculaService {
  static final _matriculaDao = MatriculaDao();
  static final _firestore = FirebaseFirestore.instance;

  static Future<void> sincronizarMatriculas() async {
    try {
      final cpfLogado = globals.cpfLogado!;
      final docRef = _firestore.collection('aulasministradas').doc(cpfLogado);
      final List<MatriculaModel> matriculas =
          await _matriculaDao.buscarMatriculasNaoSincronizadas();

      final Map<String, dynamic> atualizacoesAlunos = {};

      for (var matricula in matriculas) {
        final alunoId = matricula.idUsuario;
        final dadosAluno = {'id_estudo': matricula.idEstudoBiblico};

        // Atualiza diretamente a chave do aluno com os dados da matrícula
        atualizacoesAlunos['alunos.$alunoId'] = dadosAluno;
      }

      if (atualizacoesAlunos.isNotEmpty) {
        await docRef.set(atualizacoesAlunos, SetOptions(merge: true));
        print('Dados enviados ao Firebase com sucesso.');
      }

      for (var matricula in matriculas) {
        await _matriculaDao.atualizarSincronizacao(matricula.id!);
        print(
          'Matrícula sincronizada localmente: ID=${matricula.id}, Aluno=${matricula.idUsuario}',
        );
      }
    } catch (e) {
      print('Erro ao sincronizar matrículas com Firebase: $e');
    }
  }
}


/* import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/matricula_model.dart';
import '../models/usuario_model.dart';
import '../databases/matriculas_dao.dart';
import '../core/global.dart' as globals;

class FirebaseMatriculaService {
  static final _matriculaDao = MatriculaDao();
  static final _firestore = FirebaseFirestore.instance;

  static Future<void> sincronizarMatriculas() async {
    try {
      final cpfLogado = globals.cpfLogado!;
      final docRef = _firestore.collection('aulasministradas').doc(cpfLogado);
      final List<MatriculaModel> matriculas =
          await _matriculaDao.buscarMatriculasNaoSincronizadas();

      final Map<String, dynamic> atualizacoesAlunos = {};

      for (var matricula in matriculas) {
        final alunoId = matricula.idUsuario;
        final aulasMinistradas = [
          {'id_estudo': matricula.idEstudoBiblico},
        ];

        atualizacoesAlunos['alunos.$alunoId.aulas_ministradas'] =
            FieldValue.arrayUnion(aulasMinistradas);
      }

      if (atualizacoesAlunos.isNotEmpty) {
        await docRef.set(atualizacoesAlunos, SetOptions(merge: true));
        print('Dados enviados ao Firebase com sucesso.');
      }

      for (var matricula in matriculas) {
        await _matriculaDao.atualizarSincronizacao(matricula.id!);
        print(
          'Matrícula sincronizada localmente: ID=${matricula.id}, Aluno=${matricula.idUsuario}',
        );
      }
    } catch (e) {
      print('Erro ao sincronizar matrículas com Firebase: $e');
    }
  }
}
 */