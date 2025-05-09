import 'package:cloud_firestore/cloud_firestore.dart';

class RankingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getTop3Rankings() async {
    try {
      QuerySnapshot snapshot =
          await _firestore
              .collection('ranking')
              .orderBy('totalPontos', descending: true)
              .limit(3)
              .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'igrejaNome': data['igrejaNome'],
          'nome': data['nome'],
          'sexo': data['sexo'],
          'totalPontos': data['totalPontos'],
        };
      }).toList();
    } catch (e) {
      print('Erro ao buscar ranking: $e');
      return [];
    }
  }
}

class RankingGeralService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DocumentSnapshot? _lastDocument;

  /// Obtém a próxima página de resultados a partir do 4º colocado
  Future<List<Map<String, dynamic>>> getNextRankingPage({
    int pageSize = 10,
  }) async {
    try {
      Query query = _firestore
          .collection('ranking')
          .orderBy('totalPontos', descending: true)
          .startAtDocument(_lastDocument ?? await _getThirdPlaceDoc())
          .limit(pageSize + 1);

      QuerySnapshot snapshot = await query.get();

      if (snapshot.docs.isEmpty) return [];

      final docs =
          _lastDocument == null
              ? snapshot.docs.skip(1).toList()
              : snapshot.docs;

      if (docs.isNotEmpty) {
        _lastDocument = docs.last;
      }

      return docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'igrejaNome': data['igrejaNome'],
          'nome': data['nome'],
          'sexo': data['sexo'],
          'totalPontos': data['totalPontos'],
        };
      }).toList();
    } catch (e) {
      print('Erro ao buscar ranking geral paginado: $e');
      return [];
    }
  }

  Future<DocumentSnapshot> _getThirdPlaceDoc() async {
    QuerySnapshot snapshot =
        await _firestore
            .collection('ranking')
            .orderBy('totalPontos', descending: true)
            .limit(3)
            .get();

    return snapshot.docs.last;
  }

  void resetPagination() {
    _lastDocument = null;
  }
}
