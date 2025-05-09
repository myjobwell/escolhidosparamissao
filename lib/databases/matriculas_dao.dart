import 'package:sqflite/sqflite.dart';
import 'app_database.dart';
import '../models/matricula_model.dart';

class MatriculaDao {
  static const String _tabela = 'matriculas';

  Future<Database> get _db async => await AppDatabase.getDatabase();

  /// Insere ou substitui uma matrícula
  Future<int> insertMatricula(MatriculaModel matricula) async {
    final db = await _db;
    return await db.insert(
      _tabela,
      matricula.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Verifica se já existe matrícula local para usuário + estudo
  Future<bool> existsMatricula(String idUsuario, int idEstudoBiblico) async {
    final db = await _db;
    final result = await db.query(
      _tabela,
      columns: ['COUNT(*) as count'],
      where: 'id_usuario = ? AND id_estudo_biblico = ?',
      whereArgs: [idUsuario, idEstudoBiblico],
    );
    final count = Sqflite.firstIntValue(result) ?? 0;
    return count > 0;
  }

  /// Retorna todas as matrículas locais
  Future<List<MatriculaModel>> getTodasMatriculas() async {
    final db = await _db;
    final result = await db.query(_tabela);
    return result.map((m) => MatriculaModel.fromMap(m)).toList();
  }

  /// Retorna todas as matrículas de um usuário específico
  Future<List<MatriculaModel>> getMatriculasPorUsuario(String idUsuario) async {
    final db = await _db;
    final result = await db.query(
      _tabela,
      where: 'id_usuario = ?',
      whereArgs: [idUsuario],
    );
    return result.map((m) => MatriculaModel.fromMap(m)).toList();
  }

  /// Retorna a primeira matrícula de um usuário (ordenada por data)
  Future<MatriculaModel?> getPrimeiraMatriculaPorUsuario(
    String idUsuario,
  ) async {
    final db = await _db;
    final result = await db.query(
      _tabela,
      where: 'id_usuario = ?',
      whereArgs: [idUsuario],
      orderBy: 'data_matricula ASC',
      limit: 1,
    );
    return result.isNotEmpty ? MatriculaModel.fromMap(result.first) : null;
  }

  /// Retorna somente matrículas não sincronizadas
  Future<List<MatriculaModel>> buscarMatriculasNaoSincronizadas() async {
    final db = await _db;
    final result = await db.query(
      _tabela,
      where: 'sincronizado = ?',
      whereArgs: [0],
    );
    return result.map((m) => MatriculaModel.fromMap(m)).toList();
  }

  /// Pagina (LIMIT/OFFSET) matrículas não sincronizadas
  Future<List<MatriculaModel>> buscarMatriculasNaoSincronizadasPaginadas({
    required int limit,
    required int offset,
  }) async {
    final db = await _db;
    final result = await db.query(
      _tabela,
      where: 'sincronizado = ?',
      whereArgs: [0],
      orderBy: 'id_estudo_biblico ASC',
      limit: limit,
      offset: offset,
    );
    return result.map((m) => MatriculaModel.fromMap(m)).toList();
  }

  /// Marca matrícula como sincronizada
  Future<void> atualizarSincronizacao(int id) async {
    final db = await _db;
    await db.update(
      _tabela,
      {'sincronizado': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
