import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import '../models/estudos_biblicos_model.dart';
import 'app_database.dart';

class DbEstudos {
  /// Salva os estudos no banco local utilizando batch
  static Future<void> salvarEstudos(List<EstudoBiblico> estudos) async {
    final db = await AppDatabase.getDatabase();
    final batch = db.batch();

    for (var estudo in estudos) {
      batch.insert(
        'estudos_biblicos',
        estudo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  /// Retorna os estudos armazenados localmente
  static Future<List<EstudoBiblico>> listarEstudos() async {
    final db = await AppDatabase.getDatabase();
    final result = await db.query('estudos_biblicos');
    return result.map((e) => EstudoBiblico.fromMap(e)).toList();
  }

  /// Busca os dados da API e atualiza o banco local
  static Future<void> sincronizarEstudosComApi() async {
    try {
      final response = await http.get(
        Uri.parse('https://mipsmais.desbravadoresac.com.br/apiEstudos/'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> dados = jsonDecode(response.body);

        final estudos =
            dados
                .where(
                  (e) =>
                      e['idEstudos'] != null &&
                      e['nome'] != null &&
                      e['idEstudos'] is int &&
                      e['nome'] is String,
                )
                .map((e) => EstudoBiblico(id: e['idEstudos'], nome: e['nome']))
                .toList();

        await salvarEstudos(estudos);
      } else {
        print('Erro ao buscar dados da API (status ${response.statusCode})');
      }
    } catch (e) {
      print('Erro ao sincronizar estudos bíblicos: $e');
    }
  }
}
