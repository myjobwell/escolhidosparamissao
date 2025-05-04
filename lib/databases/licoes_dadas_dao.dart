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

  // Buscar lição dada por id
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
}
