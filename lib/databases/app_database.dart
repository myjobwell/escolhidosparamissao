import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static Database? _database;

  /*
  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    final path = join(await getDatabasesPath(), 'mipsmais.db');

    // ⚠️ Apenas durante o desenvolvimento: apagar o banco antigo para forçar recriação
    await deleteDatabase(path);

    _database = await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await _criarTabelas(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE estudos_biblicos (
              id INTEGER PRIMARY KEY,
              nome TEXT
            )
          ''');
        }
      },
    );

    return _database!;
  }
*/

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    final path = join(await getDatabasesPath(), 'mipsmais.db');

    // ⚠️ Apenas durante o desenvolvimento: apagar o banco antigo para forçar recriação
    await deleteDatabase(path);

    _database = await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await _criarTabelas(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Adicione aqui lógica de migração, se necessário
      },
    );

    return _database!;
  }

  static Future<void> _criarTabelas(Database db) async {
    await db.execute('''
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

    await db.execute('''
    CREATE TABLE estudos_biblicos (
      id INTEGER PRIMARY KEY,
      nome TEXT
    )
  ''');

    await db.execute('''
    CREATE TABLE licoes (
      idLicao INTEGER PRIMARY KEY,
      licao TEXT,
      idEstudo INTEGER,
      FOREIGN KEY (idEstudo) REFERENCES estudos_biblicos(id) ON DELETE CASCADE ON UPDATE NO ACTION
    )
  ''');

    await db.execute('''
    CREATE TABLE conteudos (
      idConteudo INTEGER PRIMARY KEY,
      pergunta TEXT,
      resposta TEXT,
      idLicao INTEGER,
      FOREIGN KEY (idLicao) REFERENCES licoes(idLicao) ON DELETE CASCADE ON UPDATE NO ACTION
    )
  ''');
  }
}
