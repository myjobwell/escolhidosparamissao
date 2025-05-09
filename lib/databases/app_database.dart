import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static Database? _database;

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    final path = join(await getDatabasesPath(), 'mipsmais.db');

    // ⚠️ Apenas durante o desenvolvimento: apagar o banco antigo para forçar recriação
    // await deleteDatabase(path);

    _database = await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await _criarTabelas(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE licoesDadas ADD COLUMN id_professor TEXT;',
          );
          await db.execute(
            'ALTER TABLE licoesDadas ADD COLUMN data_update TEXT;',
          ); // ⬅️ MIGRAÇÃO
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
        sincronizado INTEGER,
        id_professor TEXT
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

    await db.execute('''
      CREATE TABLE matriculas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_usuario TEXT,
        id_estudo_biblico INTEGER,
        sincronizado INTEGER,
        data_matricula TEXT,
        FOREIGN KEY (id_usuario) REFERENCES usuarios(id) ON DELETE CASCADE ON UPDATE NO ACTION,
        FOREIGN KEY (id_estudo_biblico) REFERENCES estudos_biblicos(id) ON DELETE CASCADE ON UPDATE NO ACTION
      )
    ''');

    await db.execute('''
      CREATE TABLE licoesDadas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_usuario TEXT,
        idLicao INTEGER,
        id_estudo_biblico INTEGER,
        sincronizado INTEGER,
        checado INTEGER DEFAULT 0,
        id_professor TEXT,
        data_update TEXT,
        FOREIGN KEY (id_usuario) REFERENCES usuarios(id) ON DELETE CASCADE ON UPDATE NO ACTION,
        FOREIGN KEY (idLicao) REFERENCES licoes(idLicao) ON DELETE CASCADE ON UPDATE NO ACTION,
        FOREIGN KEY (id_estudo_biblico) REFERENCES estudos_biblicos(id) ON DELETE CASCADE ON UPDATE NO ACTION
      )
    ''');

    await db.execute('''
      CREATE TABLE ranking (
        id TEXT PRIMARY KEY,
        nome TEXT,
        sexo TEXT,
        distritoNome TEXT,
        igrejaNome TEXT,
        totalAlunos INTEGER DEFAULT 0,
        totalAulas INTEGER DEFAULT 0,
        totalPontos INTEGER DEFAULT 0,
        updatedAt TEXT
      );
    ''');
  }
}



/* import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static Database? _database;

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    final path = join(await getDatabasesPath(), 'mipsmais.db');

    // ⚠️ Apenas durante o desenvolvimento: apagar o banco antigo para forçar recriação
    //await deleteDatabase(path);

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
        sincronizado INTEGER,
        id_professor TEXT
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

    await db.execute('''
  CREATE TABLE matriculas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_usuario TEXT,
    id_estudo_biblico INTEGER,
    sincronizado INTEGER,
    data_matricula TEXT,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id) ON DELETE CASCADE ON UPDATE NO ACTION,
    FOREIGN KEY (id_estudo_biblico) REFERENCES estudos_biblicos(id) ON DELETE CASCADE ON UPDATE NO ACTION
  )
''');

    await db.execute('''
      CREATE TABLE licoesDadas (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  id_usuario TEXT,
  idLicao INTEGER,
  id_estudo_biblico INTEGER,
  sincronizado INTEGER,
  checado INTEGER DEFAULT 0,
  FOREIGN KEY (id_usuario) REFERENCES usuarios(id) ON DELETE CASCADE ON UPDATE NO ACTION,
  FOREIGN KEY (idLicao) REFERENCES licoes(idLicao) ON DELETE CASCADE ON UPDATE NO ACTION,
  FOREIGN KEY (id_estudo_biblico) REFERENCES estudos_biblicos(id) ON DELETE CASCADE ON UPDATE NO ACTION
)

    ''');

    await db.execute('''
CREATE TABLE ranking (
  id TEXT PRIMARY KEY,
  nome TEXT,
  sexo TEXT,
  distritoNome TEXT,
  igrejaNome TEXT,
  totalAlunos INTEGER DEFAULT 0,
  totalAulas INTEGER DEFAULT 0,
  totalPontos INTEGER DEFAULT 0,
  updatedAt TEXT
);
   ''');
  }
}
 */