import 'package:sqflite/sqflite.dart';
import 'app_database.dart';
import '../models/licoes_dadas_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/global.dart';

class LicoesDadasDao {
  static const String tableName = 'licoesDadas';

  Future<Database> get _db async => await AppDatabase.getDatabase();

  /// Salva nova lição dada (ou substitui em conflito)
  Future<int> salvar(LicoesDadas licaoDada) async {
    final Database db = await _db;
    return await db.insert(
      tableName,
      licaoDada.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Busca todas as lições dadas
  Future<List<LicoesDadas>> buscarTodos() async {
    final Database db = await _db;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return maps.map((map) => LicoesDadas.fromMap(map)).toList();
  }

  /// Busca lição dada por ID
  Future<LicoesDadas?> buscarPorId(int id) async {
    final Database db = await _db;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty ? LicoesDadas.fromMap(maps.first) : null;
  }

  /// Atualiza uma lição dada
  Future<int> atualizar(LicoesDadas licaoDada) async {
    final Database db = await _db;
    return await db.update(
      tableName,
      licaoDada.toMap(),
      where: 'id = ?',
      whereArgs: [licaoDada.id],
    );
  }

  /// Deleta uma lição dada
  Future<int> deletar(int id) async {
    final Database db = await _db;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  /// Busca todas as lições de um usuário específico
  Future<List<LicoesDadas>> buscarPorUsuario(String idUsuario) async {
    final Database db = await _db;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id_usuario = ?',
      whereArgs: [idUsuario],
    );
    return maps.map((map) => LicoesDadas.fromMap(map)).toList();
  }

  /// Busca lição específica de um usuário, estudo e lição
  Future<LicoesDadas?> buscarPorUsuarioEstudoLicao(
    String idUsuario,
    int idEstudoBiblico,
    int idLicao,
  ) async {
    final Database db = await _db;
    final List<Map<String, dynamic>> resultado = await db.query(
      tableName,
      where: 'id_usuario = ? AND id_estudo_biblico = ? AND idLicao = ?',
      whereArgs: [idUsuario, idEstudoBiblico, idLicao],
      limit: 1,
    );
    return resultado.isNotEmpty ? LicoesDadas.fromMap(resultado.first) : null;
  }

  /// Retorna todas as lições pendentes (sincronizado = 0) de um estudo
  Future<List<LicoesDadas>> buscarLicoesPendentesPorEstudo(
    int idEstudoBiblico,
  ) async {
    final Database db = await _db;
    final List<Map<String, dynamic>> resultado = await db.query(
      tableName,
      where: 'id_estudo_biblico = ? AND sincronizado = ?',
      whereArgs: [idEstudoBiblico, 0],
    );
    return resultado.map((map) => LicoesDadas.fromMap(map)).toList();
  }

  /// Retorna um mapa com chave = idLicao e valor = checado (0 ou 1)
  Future<Map<int, int>> buscarStatusLicoesChecadas({
    required String idUsuario,
    required int idEstudoBiblico,
  }) async {
    final Database db = await _db;
    final List<Map<String, dynamic>> resultado = await db.query(
      tableName,
      where: 'id_usuario = ? AND id_estudo_biblico = ?',
      whereArgs: [idUsuario, idEstudoBiblico],
    );
    final Map<int, int> statusMap = {};
    for (var item in resultado) {
      final int? idLicao = int.tryParse(item['idLicao'].toString());
      final int? checado = int.tryParse(item['checado'].toString());
      if (idLicao != null && checado != null) {
        statusMap[idLicao] = checado;
      }
    }
    return statusMap;
  }

  /// Marca lição como sincronizada (sincronizado = 1)
  Future<int> atualizarSincronizacao(int id) async {
    final Database db = await _db;
    return await db.update(
      tableName,
      {'sincronizado': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Sincroniza lição com Firebase
  /// Resolvi deixar aqui porque o método é específico para a lição e aqui eu entendo melhor o que está acontecendo
  /*
    Future<void> sincronizarLicaoComFirebase(LicoesDadas licao) async {
    final docRef = FirebaseFirestore.instance
        .collection('aulasministradas')
        .doc(cpfLogado); // ou widget.idProfessor, dependendo do contexto

    final payload = {
      'id_estudo': {
        'id': licao.idEstudoBiblico,
        'data_matricula': '', // se necessário, recupere de `MatriculaDao`
        'licoes_dadas': [
          {
            'idLicao': licao.idLicao,
            'checado': licao.checado,
            'sincronizado': 1,
          },
        ],
      },
    };

    await docRef.set({
      'alunos': {licao.idUsuario: payload},
    }, SetOptions(merge: true));
  }
  */
}


/* import 'package:sqflite/sqflite.dart';
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

  // Buscar lição dada por ID
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

  // ✅ Novo método: Buscar o status de conclusão (checado) das lições para um aluno e estudo
  /*
  Future<Map<int, int>> buscarStatusLicoesChecadas({
    required String idUsuario,
    required int idEstudoBiblico,
  }) async {
    final Database db = await AppDatabase.getDatabase();

    // Consulta todas as lições marcadas como checadas ou não, para o aluno e estudo informado
    final List<Map<String, dynamic>> resultado = await db.query(
      tableName,
      where: 'id_usuario = ? AND id_estudo_biblico = ?',
      whereArgs: [idUsuario, idEstudoBiblico],
    );

    // Monta um mapa com chave: idLicao e valor: checado (0 ou 1)
    final Map<int, int> statusMap = {};
    for (var item in resultado) {
      final idLicao = item['idLicao'] as int;
      final checado = item['checado'] as int;
      statusMap[idLicao] = checado;
    }

    return statusMap;
  }
  */
  Future<Map<int, int>> buscarStatusLicoesChecadas({
    required String idUsuario,
    required int idEstudoBiblico,
  }) async {
    final Database db = await AppDatabase.getDatabase();

    final List<Map<String, dynamic>> resultado = await db.query(
      tableName,
      where: 'id_usuario = ? AND id_estudo_biblico = ?',
      whereArgs: [idUsuario, idEstudoBiblico],
    );

    final Map<int, int> statusMap = {};
    for (var item in resultado) {
      final idLicao = int.tryParse(item['idLicao'].toString());
      final checado = int.tryParse(item['checado'].toString());
      if (idLicao != null && checado != null) {
        statusMap[idLicao] = checado;
      }
    }

    return statusMap;
  }

  // Adicione este método no seu LicoesDadasDao

  Future<LicoesDadas?> buscarPorUsuarioEstudoLicao(
    String idUsuario,
    int idEstudoBiblico,
    int idLicao,
  ) async {
    final db = await AppDatabase.getDatabase();

    final resultado = await db.query(
      tableName,
      where: 'id_usuario = ? AND id_estudo_biblico = ? AND idLicao = ?',
      whereArgs: [idUsuario, idEstudoBiblico, idLicao],
      limit: 1,
    );

    if (resultado.isNotEmpty) {
      return LicoesDadas.fromMap(resultado.first);
    }
    return null;
  }
}
 */