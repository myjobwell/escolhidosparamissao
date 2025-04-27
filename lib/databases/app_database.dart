import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static Future<Database> getDatabase() async {
    final String dbName = 'mipsmais.db';
    final String path = join(await getDatabasesPath(), dbName);

    return openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE usuarios (
            id TEXT PRIMARY KEY,
            nome TEXT NOT NULL,
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
            igrejaNome TEXT
          );
        ''');
      },
    );
  }
}
