import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/licoes_dadas_model.dart';
import '../../core/global.dart'; // para acessar cpfLogado

class FirebaseLicoesService {
  static Future<void> sincronizarLicao(LicoesDadas licao) async {
    final firestore = FirebaseFirestore.instance;
    final docRef = firestore.collection('aulasministradas').doc(cpfLogado);

    final snapshot = await docRef.get();
    final data = snapshot.data() ?? {};
    final alunos = data['alunos'] as Map<String, dynamic>? ?? {};
    final alunoData = alunos[licao.idUsuario] as Map<String, dynamic>? ?? {};
    final estudo = alunoData['id_estudo'] as Map<String, dynamic>? ?? {};

    // Recupera a lista atual de lições ou cria uma nova
    final List<dynamic> licoes = estudo['licoes_dadas'] ?? [];

    // Atualiza ou insere a lição
    final index = licoes.indexWhere((item) => item['idLicao'] == licao.idLicao);

    final novaLicao = {
      'idLicao': licao.idLicao,
      'checado': licao.checado,
      'sincronizado': 1,
    };

    if (index >= 0) {
      licoes[index] = novaLicao;
    } else {
      licoes.add(novaLicao);
    }

    // Prepara o novo payload com a lista completa
    final payload = {
      'id_estudo': {
        'id': licao.idEstudoBiblico,
        'data_matricula': estudo['data_matricula'] ?? '',
        'licoes_dadas': licoes,
      },
    };

    // Grava de volta com merge
    await docRef.set({
      'alunos': {licao.idUsuario: payload},
    }, SetOptions(merge: true));
  }
}
