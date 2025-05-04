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

      // 🔹 Passo 1: Buscar dados locais e do Firebase
      final List<MatriculaModel> matriculasLocais =
          await _matriculaDao.getTodasMatriculas();

      final docSnap = await docRef.get();
      final dataRemoto = docSnap.data();
      final Map<String, dynamic> alunosFirebase =
          dataRemoto != null && dataRemoto.containsKey('alunos')
              ? Map<String, dynamic>.from(dataRemoto['alunos'])
              : {};

      final Map<String, dynamic> novosDadosParaFirebase = {'alunos': {}};

      for (final matricula in matriculasLocais) {
        final alunoId = matricula.idUsuario;
        final idEstudo = matricula.idEstudoBiblico;

        final dadosRemotosAluno = alunosFirebase[alunoId];

        final bool jaExisteNoFirebase =
            dadosRemotosAluno is Map &&
            dadosRemotosAluno.containsKey('id_estudo') &&
            dadosRemotosAluno['id_estudo'] == idEstudo;

        if (!jaExisteNoFirebase) {
          // 🔄 Se matrícula ainda não está no Firebase, adiciona
          (novosDadosParaFirebase['alunos'] as Map)[alunoId] = {
            'id_estudo': idEstudo,
          };
          print('🚀 Agendando envio de matrícula: $alunoId ➜ estudo $idEstudo');
        }
      }

      // 🔹 Passo 2: Enviar dados faltantes para o Firebase
      if ((novosDadosParaFirebase['alunos'] as Map).isNotEmpty) {
        await docRef.set(novosDadosParaFirebase, SetOptions(merge: true));
        print('✅ Matrículas locais faltantes enviadas para o Firebase.');
      } else {
        print('✔️ Nenhuma matrícula local pendente no Firebase.');
      }

      // 🔹 Passo 3: Atualiza estado local (sincronizado)
      for (var matricula in matriculasLocais) {
        await _matriculaDao.atualizarSincronizacao(matricula.id!);
      }
    } catch (e) {
      print('❌ Erro ao sincronizar matrículas com Firebase: $e');
    }
  }
}
 */
