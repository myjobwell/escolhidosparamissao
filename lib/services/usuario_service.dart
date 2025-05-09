import 'package:sqflite/sqflite.dart';
import '../models/usuario_model.dart';

class UsuarioService {
  // Listar usuários
  Future<List<Usuario>> listarUsuarios() async {
    final db = await AppDatabase.getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'usuarios',
    ); // ✅ Corrigido

    return List.generate(maps.length, (i) {
      return Usuario.fromMap(maps[i], maps[i]['id']);
    });
  }

  // Criar novo usuário
  Future<void> criarUsuario(Usuario usuario) async {
    final db = await AppDatabase.getDatabase();
    await db.insert(
      'usuarios',
      usuario.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Deletar usuário
  Future<void> deletarUsuario(String id) async {
    final db = await AppDatabase.getDatabase();
    await db.delete('usuarios', where: 'id = ?', whereArgs: [id]);
  }

  // Atualizar usuário
  /*   Future<void> atualizarUsuario(Usuario usuario) async {
    final db = await AppDatabase.getDatabase();
    if (usuario.id != null) {
      await db.update(
        'usuarios',
        usuario.toMap(),
        where: 'id = ?',
        whereArgs: [usuario.id],
      );
    }
  } */
}

class AppDatabase {
  static getDatabase() {}
}
