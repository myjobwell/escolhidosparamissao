import 'package:sqflite/sqflite.dart';
import '../models/usuario_model.dart';
import 'app_database.dart';

class DbUsuario {
  /// Salvar ou atualizar um usuário localmente
  static Future<void> salvarUsuario(Usuario usuario) async {
    final db = await AppDatabase.getDatabase();

    await db.insert(
      'usuarios',
      usuario.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Buscar um usuário pelo CPF
  static Future<Usuario?> buscarUsuarioPorCpf(String cpf) async {
    final db = await AppDatabase.getDatabase();

    final result = await db.query(
      'usuarios',
      where: 'cpf = ?',
      whereArgs: [cpf],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return Usuario.fromMap(result.first, cpf);
    } else {
      return null;
    }
  }

  /// Atualizar apenas o campo 'sincronizado' com base no ID do usuário
  static Future<void> atualizarSincronizacao(String id) async {
    final db = await AppDatabase.getDatabase();

    await db.update(
      'usuarios',
      {'sincronizado': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //Funcao para sincronizar o usuario
  static Future<List<Usuario>> getUsuariosNaoSincronizados() async {
    final db = await AppDatabase.getDatabase();

    final maps = await db.query(
      'usuarios',
      where: 'sincronizado = ?',
      whereArgs: [0],
    );

    return maps
        .map((map) => Usuario.fromMap(map, map['id'] as String))
        .toList();
  }

  /// Buscar usuários não sincronizados
  static Future<List<Usuario>> buscarUsuariosNaoSincronizados() async {
    final db = await AppDatabase.getDatabase();

    final result = await db.query('usuarios', where: 'sincronizado = 0');

    return result.map((e) => Usuario.fromMap(e, e['cpf'] as String)).toList();
  }
}
