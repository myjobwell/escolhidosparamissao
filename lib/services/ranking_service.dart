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
