import 'package:sqflite/sqflite.dart';
import 'app_database.dart';
import '../models/licoes_dadas_model.dart';

class LicoesDadasDao {
  static const String tableName = 'licoesDadas';

  // Salvar nova lição dada
  Future<int> salvar(LicoesDadas licaoDada) async {
    final Database db = await AppDatabase.getDatabase();
    return await db.insert(
      tableName,
      licaoDada.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Buscar todas as lições dadas
  Future<List<LicoesDadas>> buscarTodos() async {
    final Database db = await AppDatabase.getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return maps.map((map) => LicoesDadas.fromMap(map)).toList();
  }

  // Buscar lição dada por ID
  Future<LicoesDadas?> buscarPorId(int id) async {
    final Database db = await AppDatabase.getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    return maps.isNotEmpty ? LicoesDadas.fromMap(maps.first) : null;
  }

  // Atualizar uma lição dada
  Future<int> atualizar(LicoesDadas licaoDada) async {
    final Database db = await AppDatabase.getDatabase();
    return await db.update(
      tableName,
      licaoDada.toMap(),
      where: 'id = ?',
      whereArgs: [licaoDada.id],
    );
  }

  // Deletar uma lição dada
  Future<int> deletar(int id) async {
    final Database db = await AppDatabase.getDatabase();
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  // Buscar lições dadas por usuário específico
  Future<List<LicoesDadas>> buscarPorUsuario(String idUsuario) async {
    final Database db = await AppDatabase.getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id_usuario = ?',
      whereArgs: [idUsuario],
    );

    return maps.map((map) => LicoesDadas.fromMap(map)).toList();
  }

  // ✅ Novo método: Buscar o status de conclusão (checado) das lições para um aluno e estudo
  /*
  Future<Map<int, int>> buscarStatusLicoesChecadas({
    required String idUsuario,
    required int idEstudoBiblico,
  }) async {
    final Database db = await AppDatabase.getDatabase();

    // Consulta todas as lições marcadas como checadas ou não, para o aluno e estudo informado
    final List<Map<String, dynamic>> resultado = await db.query(
      tableName,
      where: 'id_usuario = ? AND id_estudo_biblico = ?',
      whereArgs: [idUsuario, idEstudoBiblico],
    );

    // Monta um mapa com chave: idLicao e valor: checado (0 ou 1)
    final Map<int, int> statusMap = {};
    for (var item in resultado) {
      final idLicao = item['idLicao'] as int;
      final checado = item['checado'] as int;
      statusMap[idLicao] = checado;
    }

    return statusMap;
  }
  */
  Future<Map<int, int>> buscarStatusLicoesChecadas({
    required String idUsuario,
    required int idEstudoBiblico,
  }) async {
    final Database db = await AppDatabase.getDatabase();

    final List<Map<String, dynamic>> resultado = await db.query(
      tableName,
      where: 'id_usuario = ? AND id_estudo_biblico = ?',
      whereArgs: [idUsuario, idEstudoBiblico],
    );

    final Map<int, int> statusMap = {};
    for (var item in resultado) {
      final idLicao = int.tryParse(item['idLicao'].toString());
      final checado = int.tryParse(item['checado'].toString());
      if (idLicao != null && checado != null) {
        statusMap[idLicao] = checado;
      }
    }

    return statusMap;
  }

  // Adicione este método no seu LicoesDadasDao

  Future<LicoesDadas?> buscarPorUsuarioEstudoLicao(
    String idUsuario,
    int idEstudoBiblico,
    int idLicao,
  ) async {
    final db = await AppDatabase.getDatabase();

    final resultado = await db.query(
      tableName,
      where: 'id_usuario = ? AND id_estudo_biblico = ? AND idLicao = ?',
      whereArgs: [idUsuario, idEstudoBiblico, idLicao],
      limit: 1,
    );

    if (resultado.isNotEmpty) {
      return LicoesDadas.fromMap(resultado.first);
    }
    return null;
  }
}
