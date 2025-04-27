import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/usuario_model.dart';

class DbUsuario {
  static Future<Database> _getDatabase() async {
    final path = join(await getDatabasesPath(), 'mipsmais.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE usuarios (
            id TEXT PRIMARY KEY,
            nome TEXT,
            cpf TEXT,
            sexo TEXT,
            telefone TEXT,
            email TEXT,
            nascimento TEXT,
            tipo_usuario TEXT,
            divisaoId INTEGER,
            divisaoNome TEXT,
            uniaoId INTEGER,
            uniaoNome TEXT,
            associacaoId INTEGER,
            associacaoNome TEXT,
            distritoId INTEGER,
            distritoNome TEXT,
            igrejaId TEXT,
            igrejaNome TEXT,
            sincronizado INTEGER
          )
        ''');
      },
    );
  }

  /// Salvar um novo usuário ou atualizar se já existir
  static Future<void> salvarUsuario(Usuario usuario) async {
    final db = await _getDatabase();

    await db.insert(
      'usuarios',
      usuario.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Atualizar apenas o campo de sincronização
  static Future<void> atualizarSincronizacao(String cpf) async {
    final db = await _getDatabase();

    await db.update(
      'usuarios',
      {'sincronizado': 1},
      where: 'cpf = ?',
      whereArgs: [cpf],
    );
  }

  /// Buscar todos usuários que não estão sincronizados
  static Future<List<Usuario>> buscarUsuariosNaoSincronizados() async {
    final db = await _getDatabase();
    final result = await db.query('usuarios', where: 'sincronizado = 0');

    return result.map((e) => Usuario.fromMap(e, e['cpf'] as String?)).toList();
  }

  /// Buscar um usuário pelo CPF
  static Future<Usuario?> buscarUsuarioPorCpf(String cpf) async {
    final db = await _getDatabase();
    final result = await db.query(
      'usuarios',
      where: 'cpf = ?',
      whereArgs: [cpf],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return Usuario.fromMap(result.first, result.first['cpf'] as String?);
    } else {
      return null;
    }
  }
}
