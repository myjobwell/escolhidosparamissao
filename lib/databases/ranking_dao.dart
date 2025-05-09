import 'package:sqflite/sqflite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ranking_model.dart';

class RankingDao {
  final Database db;

  RankingDao(this.db);

  Future<void> upsertRanking(RankingModel ranking) async {
    await db.insert(
      'ranking',
      ranking.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertRanking(RankingModel ranking) async {
    await db.insert('ranking', ranking.toMap());
  }

  Future<void> updateRanking(RankingModel ranking) async {
    await db.update(
      'ranking',
      ranking.toMap(),
      where: 'id = ?',
      whereArgs: [ranking.id],
    );
  }

  Future<RankingModel?> getRankingById(String id) async {
    final result = await db.query(
      'ranking',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return RankingModel.fromMap(result.first);
    }
    return null;
  }

  Future<List<RankingModel>> getAllRankings() async {
    final result = await db.query('ranking');
    return result.map((e) => RankingModel.fromMap(e)).toList();
  }

  Future<void> deleteRanking(String id) async {
    await db.delete('ranking', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> syncWithFirestore(RankingModel ranking) async {
    final docRef = FirebaseFirestore.instance
        .collection('ranking')
        .doc(ranking.id);

    await docRef.set({
      ...ranking.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> syncFromFirestore(String id) async {
    final doc =
        await FirebaseFirestore.instance.collection('ranking').doc(id).get();
    if (doc.exists) {
      final data = RankingModel.fromMap(doc.data()!);
      await upsertRanking(data);
    }
  }

  Future<void> registrarCadastroAluno({
    required String id,
    required String nome,
    required String sexo,
    required String distritoNome,
    required String igrejaNome,
  }) async {
    final now = DateTime.now().toIso8601String();
    final rankingExistente = await getRankingById(id);

    if (rankingExistente == null) {
      final novo = RankingModel(
        id: id,
        nome: nome,
        sexo: sexo,
        distritoNome: distritoNome,
        igrejaNome: igrejaNome,
        totalAlunos: 1,
        totalAulas: 0,
        totalPontos: 1,
        updatedAt: now,
      );
      await insertRanking(novo);
      await syncWithFirestore(novo);
      print("✅ Novo ranking criado para $id");
    } else {
      final atualizado = RankingModel(
        id: id,
        nome: rankingExistente.nome,
        sexo: rankingExistente.sexo,
        distritoNome: rankingExistente.distritoNome,
        igrejaNome: rankingExistente.igrejaNome,
        totalAlunos: rankingExistente.totalAlunos + 1,
        totalAulas: rankingExistente.totalAulas,
        totalPontos:
            (rankingExistente.totalAlunos + 1) + rankingExistente.totalAulas,
        updatedAt: now,
      );
      await updateRanking(atualizado);
      await syncWithFirestore(atualizado);
      print("🔁 Ranking atualizado para $id");
    }
  }

  Future<void> atualizarTotalAulas({
    required String idProfessor,
    required bool incrementar,
  }) async {
    final now = DateTime.now().toIso8601String();
    final ranking = await getRankingById(idProfessor);

    if (ranking != null) {
      final novoTotalAulas = (ranking.totalAulas + (incrementar ? 1 : -1))
          .clamp(0, 9999);
      final novoTotalPontos = ranking.totalAlunos + novoTotalAulas;

      final atualizado = RankingModel(
        id: ranking.id,
        nome: ranking.nome,
        sexo: ranking.sexo,
        distritoNome: ranking.distritoNome,
        igrejaNome: ranking.igrejaNome,
        totalAlunos: ranking.totalAlunos,
        totalAulas: novoTotalAulas,
        totalPontos: novoTotalPontos,
        updatedAt: now,
      );

      await updateRanking(atualizado);
      await syncWithFirestore(atualizado);
      print("🔁 totalAulas ${incrementar ? '+' : '-'}1 em ${ranking.id}");
    }
  }
}
