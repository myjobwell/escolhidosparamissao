import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import '../models/estudos_biblicos_model.dart';
import '../models/licoes_model.dart';
import '../models/conteudo_model.dart';
import 'app_database.dart';

class DbEstudos {
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

  static Future<void> salvarLicoes(List<Licao> licoes) async {
    final db = await AppDatabase.getDatabase();
    final batch = db.batch();

    for (var licao in licoes) {
      batch.insert(
        'licoes',
        licao.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  static Future<void> salvarConteudos(List<Conteudo> conteudos) async {
    final db = await AppDatabase.getDatabase();
    final batch = db.batch();

    for (var c in conteudos) {
      batch.insert(
        'conteudos',
        c.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  static Future<List<EstudoBiblico>> listarEstudos() async {
    final db = await AppDatabase.getDatabase();
    final result = await db.query('estudos_biblicos');
    return result.map((e) => EstudoBiblico.fromMap(e)).toList();
  }

  static Future<List<Licao>> listarLicoesPorEstudo(int idEstudo) async {
    final db = await AppDatabase.getDatabase();
    final result = await db.query(
      'licoes',
      where: 'idEstudo = ?',
      whereArgs: [idEstudo],
    );
    return result.map((e) => Licao.fromMap(e)).toList();
  }

  static Future<List<Conteudo>> listarConteudosPorLicao(int idLicao) async {
    final db = await AppDatabase.getDatabase();
    final result = await db.query(
      'conteudos',
      where: 'idLicao = ?',
      whereArgs: [idLicao],
    );
    return result.map((e) => Conteudo.fromMap(e)).toList();
  }

  static Future<void> sincronizarEstudosComApi() async {
    try {
      print('🔄 Iniciando sincronização com a API de estudos...');

      final estudosResponse = await http.get(
        Uri.parse('https://mipsmais.desbravadoresac.com.br/apiEstudos/'),
      );
      final estudosBody = utf8.decode(estudosResponse.bodyBytes);

      if (estudosResponse.statusCode == 200) {
        final List<dynamic> dadosEstudos = jsonDecode(estudosBody);

        final estudos =
            dadosEstudos
                .where((e) => e['id'] != null && e['nome'] != null)
                .map((e) => EstudoBiblico(id: e['id'], nome: e['nome']))
                .toList();

        await salvarEstudos(estudos);
        print('✅ ${estudos.length} estudos salvos.');
      }

      print('🔄 Buscando lições...');
      final licoesResponse = await http.get(
        Uri.parse('https://mipsmais.desbravadoresac.com.br/apiLicoes/'),
      );
      final licoesBody = utf8.decode(licoesResponse.bodyBytes);

      if (licoesResponse.statusCode == 200) {
        final List<dynamic> dadosLicoes = jsonDecode(licoesBody);

        final licoes =
            dadosLicoes
                .where(
                  (e) =>
                      e['idLicao'] != null &&
                      e['licao'] != null &&
                      e['idEstudo'] != null,
                )
                .map(
                  (e) => Licao(
                    id: e['idLicao'],
                    nome: e['licao'],
                    idEstudo: e['idEstudo'],
                  ),
                )
                .toList();

        await salvarLicoes(licoes);
        print('✅ ${licoes.length} lições salvas.');
      }

      print('🔄 Buscando conteúdos...');
      final conteudosResponse = await http.get(
        Uri.parse('https://mipsmais.desbravadoresac.com.br/apiConteudo/'),
      );
      final conteudosBody = utf8.decode(conteudosResponse.bodyBytes);

      if (conteudosResponse.statusCode == 200) {
        final List<dynamic> dadosConteudos = jsonDecode(conteudosBody);

        final conteudos =
            dadosConteudos
                .where(
                  (e) =>
                      e['idConteudo'] != null &&
                      e['pergunta'] != null &&
                      e['resposta'] != null &&
                      e['idLicao'] != null,
                )
                .map(
                  (e) => Conteudo(
                    idConteudo: e['idConteudo'],
                    pergunta: e['pergunta'],
                    resposta: e['resposta'],
                    idLicao: e['idLicao'],
                  ),
                )
                .toList();

        await salvarConteudos(conteudos);
        print('✅ ${conteudos.length} conteúdos salvos.');
      }
    } catch (e) {
      print('❌ Erro ao sincronizar dados: $e');
    }
  }
}
