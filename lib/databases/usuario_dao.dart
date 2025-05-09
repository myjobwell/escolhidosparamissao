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

  /// Buscar todos os usuários cujo id_professor seja igual ao CPF logado
  static Future<List<Usuario>> buscarUsuariosPorProfessor(
    String cpfProfessor,
  ) async {
    final db = await AppDatabase.getDatabase();

    final result = await db.query(
      'usuarios',
      where: 'id_professor = ?',
      whereArgs: [cpfProfessor],
    );

    return result
        .map((map) => Usuario.fromMap(map, map['id'] as String))
        .toList();
  }

  /// Somatório dos usuários por professor
  static Future<int> contarUsuariosPorProfessor(String cpfProfessor) async {
    final db = await AppDatabase.getDatabase();

    final result = await db.rawQuery(
      'SELECT COUNT(*) as total FROM usuarios WHERE id_professor = ?',
      [cpfProfessor],
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Buscar o último usuário criado (por ID descendente)
  static Future<Usuario?> buscarUltimoUsuario() async {
    final db = await AppDatabase.getDatabase();

    final result = await db.query('usuarios', orderBy: 'id DESC', limit: 1);

    if (result.isNotEmpty) {
      return Usuario.fromMap(result.first, result.first['cpf'] as String);
    }
    return null;
  }

  static Future<Usuario?> buscarUsuarioPorId(String id) async {
    final db = await AppDatabase.getDatabase();
    final result = await db.query(
      'usuarios',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return Usuario.fromMap(result.first, result.first['cpf'] as String);
    } else {
      return null;
    }
  }
}
