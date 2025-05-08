import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/ranking_model.dart';
import '../../databases/ranking_dao.dart';
import '../../databases/app_database.dart';

class SincronizaRanking {
  static Future<void> sincronizar(String id) async {
    if (id.isEmpty) {
      print("⚠️ ID inválido para sincronização.");
      return;
    }

    final db = await AppDatabase.getDatabase();
    final dao = RankingDao(db);

    final local = await dao.getRankingById(id);

    final doc =
        await FirebaseFirestore.instance.collection('ranking').doc(id).get();
    final remoto = doc.exists ? RankingModel.fromMap(doc.data()!) : null;

    if (local == null && remoto != null) {
      await dao.upsertRanking(remoto);
      print("⬇️ Ranking baixado do Firestore para $id.");
    } else if (local != null && remoto == null) {
      await _enviarParaFirestore(local);
      print("⬆️ Ranking enviado ao Firestore: $id.");
    } else if (local != null && remoto != null) {
      final localTime = DateTime.tryParse(local.updatedAt);
      final remoteTime = DateTime.tryParse(remoto.updatedAt);

      if (remoteTime != null && localTime != null) {
        if (remoteTime.isAfter(localTime)) {
          await dao.upsertRanking(remoto);
          print("⬇️ Atualizado local com Firestore para $id.");
        } else if (localTime.isAfter(remoteTime)) {
          await _enviarParaFirestore(local);
          print("⬆️ Atualizado Firestore com dados locais para $id.");
        } else {
          print("🔁 Dados já sincronizados para $id.");
        }
      }
    } else {
      print("⚠️ Nenhum dado encontrado localmente ou remotamente para $id.");
    }
  }

  static Future<void> _enviarParaFirestore(RankingModel ranking) async {
    final docRef = FirebaseFirestore.instance
        .collection('ranking')
        .doc(ranking.id);
    await docRef.set({
      ...ranking.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
