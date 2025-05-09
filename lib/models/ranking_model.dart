import 'package:cloud_firestore/cloud_firestore.dart';

class RankingModel {
  final String id;
  final String nome;
  final String sexo;
  final String distritoNome;
  final String igrejaNome;
  final int totalAlunos;
  final int totalAulas;
  final int totalPontos;
  final String updatedAt; // ISO8601 string format

  RankingModel({
    required this.id,
    required this.nome,
    required this.sexo,
    required this.distritoNome,
    required this.igrejaNome,
    required this.totalAlunos,
    required this.totalAulas,
    required this.totalPontos,
    required this.updatedAt,
  });

  factory RankingModel.fromMap(Map<String, dynamic> map) {
    final updatedAtValue = map['updatedAt'];
    String updatedAtStr;

    if (updatedAtValue is Timestamp) {
      updatedAtStr = updatedAtValue.toDate().toIso8601String(); // Firestore
    } else if (updatedAtValue is String) {
      updatedAtStr = updatedAtValue; // SQLite ou Firestore com merge
    } else {
      updatedAtStr = DateTime.now().toIso8601String(); // fallback seguro
    }

    return RankingModel(
      id: map['id'],
      nome: map['nome'] ?? '',
      sexo: map['sexo'] ?? '',
      distritoNome: map['distritoNome'] ?? '',
      igrejaNome: map['igrejaNome'] ?? '',
      totalAlunos: map['totalAlunos'] ?? 0,
      totalAulas: map['totalAulas'] ?? 0,
      totalPontos: map['totalPontos'] ?? 0,
      updatedAt: updatedAtStr,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'sexo': sexo,
      'distritoNome': distritoNome,
      'igrejaNome': igrejaNome,
      'totalAlunos': totalAlunos,
      'totalAulas': totalAulas,
      'totalPontos': totalPontos,
      'updatedAt': updatedAt,
    };
  }
}

/* import 'package:cloud_firestore/cloud_firestore.dart';

class RankingModel {
  final String id;
  final String nome;
  final String distritoNome;
  final String igrejaNome;
  final int totalAlunos;
  final int totalAulas;
  final int totalPontos;
  final String updatedAt; // ISO8601 string format

  RankingModel({
    required this.id,
    required this.nome,
    required this.distritoNome,
    required this.igrejaNome,
    required this.totalAlunos,
    required this.totalAulas,
    required this.totalPontos,
    required this.updatedAt,
  });

  // 🔄 Converte de Map (SQLite ou Firestore) para RankingModel
  factory RankingModel.fromMap(Map<String, dynamic> map) {
    // ✅ CORREÇÃO AQUI: trata diferentes tipos de entrada para o campo updatedAt
    final updatedAtValue = map['updatedAt'];
    String updatedAtStr;

    if (updatedAtValue is Timestamp) {
      updatedAtStr = updatedAtValue.toDate().toIso8601String(); // Firestore
    } else if (updatedAtValue is String) {
      updatedAtStr = updatedAtValue; // SQLite ou Firestore com merge
    } else {
      updatedAtStr = DateTime.now().toIso8601String(); // fallback seguro
    }

    return RankingModel(
      id: map['id'],
      nome: map['nome'] ?? '',
      distritoNome: map['distritoNome'] ?? '',
      igrejaNome: map['igrejaNome'] ?? '',
      totalAlunos: map['totalAlunos'] ?? 0,
      totalAulas: map['totalAulas'] ?? 0,
      totalPontos: map['totalPontos'] ?? 0,
      updatedAt: updatedAtStr,
    );
  }

  // 🔄 Converte RankingModel para Map (para salvar no SQLite ou Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'distritoNome': distritoNome,
      'igrejaNome': igrejaNome,
      'totalAlunos': totalAlunos,
      'totalAulas': totalAulas,
      'totalPontos': totalPontos,
      'updatedAt': updatedAt,
    };
  }
} */
