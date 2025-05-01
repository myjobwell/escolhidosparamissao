import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import '../models/estudos_biblicos_model.dart';
import '../models/licoes_model.dart';
import 'app_database.dart';

class DbEstudos {
  /// Salva os estudos no banco local
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

  /// Salva as lições no banco local
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

  /// Lista os estudos do banco
  static Future<List<EstudoBiblico>> listarEstudos() async {
    final db = await AppDatabase.getDatabase();
    final result = await db.query('estudos_biblicos');
    return result.map((e) => EstudoBiblico.fromMap(e)).toList();
  }

  /// Lista as lições do banco
  static Future<List<Licao>> listarLicoesPorEstudo(int estudoId) async {
    final db = await AppDatabase.getDatabase();
    final result = await db.query(
      'licoes',
      where: 'estudoId = ?',
      whereArgs: [estudoId],
    );
    return result.map((e) => Licao.fromMap(e)).toList();
  }

  /// Sincroniza estudos e lições da API em uma só chamada
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
        print('✅ ${estudos.length} estudos salvos no banco local.');
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
                    estudoId: e['idEstudo'],
                  ),
                )
                .toList();

        await salvarLicoes(licoes);
        print('✅ ${licoes.length} lições salvas no banco local.');
      }
    } catch (e) {
      print('❌ Erro ao sincronizar dados: $e');
    }
  }
}



/* import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import '../models/estudos_biblicos_model.dart';
import 'app_database.dart';
import 'dart:convert';

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
  /*
  static Future<void> sincronizarEstudosComApi() async {
    try {
      // ⚠️ Apenas durante o desenvolvimento:
      print('Iniciando sincronização com a API...');

      final response = await http.get(
        Uri.parse('https://mipsmais.desbravadoresac.com.br/apiEstudos/'),
      );

      // ⚠️ Apenas durante o desenvolvimento:
      print('Resposta da API: ${response.statusCode}');
      print('Corpo da resposta: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> dados = jsonDecode(response.body);

        final estudos =
            dados
                .where(
                  (e) =>
                      e['id'] != null &&
                      e['nome'] != null &&
                      e['id'] is int &&
                      e['nome'] is String,
                )
                .map((e) => EstudoBiblico(id: e['id'], nome: e['nome']))
                .toList();

        await salvarEstudos(estudos);

        // ⚠️ Apenas durante o desenvolvimento:
        print('${estudos.length} estudos salvos no banco local.');
      } else {
        print('Erro ao buscar dados da API (status ${response.statusCode})');
      }
    } catch (e) {
      print('Erro ao sincronizar estudos bíblicos: $e');
    }
  }
*/
  static Future<void> sincronizarEstudosComApi() async {
    try {
      print('Iniciando sincronização com a API...');

      final response = await http.get(
        Uri.parse('https://mipsmais.desbravadoresac.com.br/apiEstudos/'),
      );

      print('Resposta da API: ${response.statusCode}');

      final decodedBody = utf8.decode(response.bodyBytes); // <- forçando UTF-8
      print('Corpo decodificado: $decodedBody');

      if (response.statusCode == 200) {
        final List<dynamic> dados = jsonDecode(decodedBody);

        final estudos =
            dados
                .where(
                  (e) =>
                      e['id'] != null &&
                      e['nome'] != null &&
                      e['id'] is int &&
                      e['nome'] is String,
                )
                .map((e) => EstudoBiblico(id: e['id'], nome: e['nome']))
                .toList();

        await salvarEstudos(estudos);
        print('${estudos.length} estudos salvos no banco local.');
      } else {
        print('Erro ao buscar dados da API (status ${response.statusCode})');
      }
    } catch (e) {
      print('Erro ao sincronizar estudos bíblicos: $e');
    }
  }
}
 */