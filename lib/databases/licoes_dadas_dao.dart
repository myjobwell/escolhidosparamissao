import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'app_database.dart';
import '../models/licoes_dadas_model.dart';

class LicoesDadasDao {
  static const String tableName = 'licoesDadas';

  Future<Database> get _db async => await AppDatabase.getDatabase();

  String _dataAtualFormatada() {
    final now = DateTime.now();
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  }

  /// Salva nova lição dada (ou substitui em conflito)
  Future<int> salvar(LicoesDadas licaoDada) async {
    final Database db = await _db;
    final licaoComData = licaoDada.copyWith(dataUpdate: _dataAtualFormatada());
    return await db.insert(
      tableName,
      licaoComData.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Atualiza uma lição dada
  Future<int> atualizar(LicoesDadas licaoDada) async {
    final Database db = await _db;
    final licaoComData = licaoDada.copyWith(dataUpdate: _dataAtualFormatada());
    return await db.update(
      tableName,
      licaoComData.toMap(),
      where: 'id = ?',
      whereArgs: [licaoDada.id],
    );
  }

  /// Deleta uma lição dada
  Future<int> deletar(int id) async {
    final Database db = await _db;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  /// Busca todas as lições dadas
  Future<List<LicoesDadas>> buscarTodos() async {
    final Database db = await _db;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return maps.map((map) => LicoesDadas.fromMap(map)).toList();
  }

  /// Busca lição dada por ID
  Future<LicoesDadas?> buscarPorId(int id) async {
    final Database db = await _db;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty ? LicoesDadas.fromMap(maps.first) : null;
  }

  /// Busca todas as lições de um usuário específico
  Future<List<LicoesDadas>> buscarPorUsuario(String idUsuario) async {
    final Database db = await _db;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id_usuario = ?',
      whereArgs: [idUsuario],
    );
    return maps.map((map) => LicoesDadas.fromMap(map)).toList();
  }

  /// Busca lição específica de um usuário, estudo e lição
  Future<LicoesDadas?> buscarPorUsuarioEstudoLicao(
    String idUsuario,
    int idEstudoBiblico,
    int idLicao,
  ) async {
    final Database db = await _db;
    final List<Map<String, dynamic>> resultado = await db.query(
      tableName,
      where: 'id_usuario = ? AND id_estudo_biblico = ? AND idLicao = ?',
      whereArgs: [idUsuario, idEstudoBiblico, idLicao],
      limit: 1,
    );
    return resultado.isNotEmpty ? LicoesDadas.fromMap(resultado.first) : null;
  }

  /// Retorna todas as lições pendentes (sincronizado = 0) de um estudo
  Future<List<LicoesDadas>> buscarLicoesPendentesPorEstudo(
    int idEstudoBiblico,
  ) async {
    final Database db = await _db;
    final List<Map<String, dynamic>> resultado = await db.query(
      tableName,
      where: 'id_estudo_biblico = ? AND sincronizado = ?',
      whereArgs: [idEstudoBiblico, 0],
    );
    return resultado.map((map) => LicoesDadas.fromMap(map)).toList();
  }

  /// Retorna um mapa com chave = idLicao e valor = checado (0 ou 1)
  Future<Map<int, int>> buscarStatusLicoesChecadas({
    required String idUsuario,
    required int idEstudoBiblico,
  }) async {
    final Database db = await _db;
    final List<Map<String, dynamic>> resultado = await db.query(
      tableName,
      where: 'id_usuario = ? AND id_estudo_biblico = ?',
      whereArgs: [idUsuario, idEstudoBiblico],
    );
    final Map<int, int> statusMap = {};
    for (var item in resultado) {
      final int? idLicao = int.tryParse(item['idLicao'].toString());
      final int? checado = int.tryParse(item['checado'].toString());
      if (idLicao != null && checado != null) {
        statusMap[idLicao] = checado;
      }
    }
    return statusMap;
  }

  /// Marca lição como sincronizada (sincronizado = 1)
  Future<int> atualizarSincronizacao(int id) async {
    final Database db = await _db;
    return await db.update(
      tableName,
      {
        'sincronizado': 1,
        'data_update': _dataAtualFormatada(), // atualiza data ao sincronizar
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Soma das lições dadas
  static Future<int> contarLicoesChecadasPorProfessor(String cpfLogado) async {
    final db = await AppDatabase.getDatabase();
    final result = await db.rawQuery(
      'SELECT COUNT(*) as total FROM licoesDadas WHERE checado = 1 AND id_professor = ?',
      [cpfLogado],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Busca todas as lições dadas por um professor
  Future<List<LicoesDadas>> buscarPorProfessor(String idProfessor) async {
    final Database db = await _db;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id_professor = ?',
      whereArgs: [idProfessor],
    );
    return maps.map((map) => LicoesDadas.fromMap(map)).toList();
  }

  /// Retorna todas as lições não sincronizadas (sincronizado = 0)
  Future<List<LicoesDadas>> buscarLicoesNaoSincronizadas() async {
    final Database db = await _db;
    final List<Map<String, dynamic>> resultado = await db.query(
      tableName,
      where: 'sincronizado = ?',
      whereArgs: [0],
    );
    return resultado.map((map) => LicoesDadas.fromMap(map)).toList();
  }
}
