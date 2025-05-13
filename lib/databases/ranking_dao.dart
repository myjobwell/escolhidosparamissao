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

    final atualizado = RankingModel(
      id: ranking.id,
      nome: ranking.nome,
      sexo: ranking.sexo,
      distritoNome: ranking.distritoNome,
      igrejaNome: ranking.igrejaNome,
      totalAlunos: ranking.totalAlunos,
      totalAulas: ranking.totalAulas,
      totalPontos: ranking.totalPontos,
      updatedAt: ranking.updatedAt,
      sincronizado: true,
    );

    await updateRanking(atualizado);
  }

  Future<void> syncFromFirestore(String id) async {
    final doc =
        await FirebaseFirestore.instance.collection('ranking').doc(id).get();
    if (doc.exists) {
      final data = RankingModel.fromMap(doc.data()!);
      final sincronizado = data.copyWith(sincronizado: true);
      await upsertRanking(sincronizado);
    }
  }

  Future<void> registrarCadastroAluno({
    required String id,
    required String nome,
    required String sexo,
    required String distritoNome,
    required String igrejaNome,
    bool sincronizar = true,
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
        sincronizado: false,
      );
      await insertRanking(novo);
      if (sincronizar) {
        try {
          await syncWithFirestore(novo);
        } catch (e) {
          print("❌ Falha ao sincronizar novo ranking com Firebase: $e");
        }
      }
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
        sincronizado: false,
      );
      await updateRanking(atualizado);
      if (sincronizar) {
        try {
          await syncWithFirestore(atualizado);
        } catch (e) {
          print(
            "❌ Falha ao sincronizar atualização de ranking com Firebase: $e",
          );
        }
      }
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
        sincronizado: false,
      );

      await updateRanking(atualizado);
      await syncWithFirestore(atualizado);
      print("🔁 totalAulas ${incrementar ? '+' : '-'}1 em ${ranking.id}");
    }
  }
}

extension on RankingModel {
  RankingModel copyWith({
    String? id,
    String? nome,
    String? sexo,
    String? distritoNome,
    String? igrejaNome,
    int? totalAlunos,
    int? totalAulas,
    int? totalPontos,
    String? updatedAt,
    bool? sincronizado,
  }) {
    return RankingModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      sexo: sexo ?? this.sexo,
      distritoNome: distritoNome ?? this.distritoNome,
      igrejaNome: igrejaNome ?? this.igrejaNome,
      totalAlunos: totalAlunos ?? this.totalAlunos,
      totalAulas: totalAulas ?? this.totalAulas,
      totalPontos: totalPontos ?? this.totalPontos,
      updatedAt: updatedAt ?? this.updatedAt,
      sincronizado: sincronizado ?? this.sincronizado,
    );
  }
}
