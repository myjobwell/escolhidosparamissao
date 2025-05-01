import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static Database? _database;

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    final path = join(await getDatabasesPath(), 'mipsmais.db');

    _database = await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await _criarTabelas(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Este bloco é útil quando você precisa adicionar novas tabelas em versões futuras
        if (oldVersion < 2) {
          // Neste exemplo, nenhuma nova tabela além das do onCreate
          // Futuras tabelas podem ser adicionadas aqui
        }
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
  }
}
