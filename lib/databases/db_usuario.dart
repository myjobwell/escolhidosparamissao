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

  /// Atualizar apenas o campo 'sincronizado'
  static Future<void> atualizarSincronizacao(String cpf) async {
    final db = await AppDatabase.getDatabase();

    await db.update(
      'usuarios',
      {'sincronizado': 1},
      where: 'cpf = ?',
      whereArgs: [cpf],
    );
  }

  /// Buscar usuários não sincronizados
  static Future<List<Usuario>> buscarUsuariosNaoSincronizados() async {
    final db = await AppDatabase.getDatabase();

    final result = await db.query('usuarios', where: 'sincronizado = 0');

    return result.map((e) => Usuario.fromMap(e, e['cpf'] as String)).toList();
  }
}
