import 'package:sqflite/sqflite.dart';
import '../databases/app_database.dart';
import '../models/matricula_model.dart';

class MatriculaDao {
  static const String _tabela = 'matriculas';

  /// Insere uma nova matrícula
  Future<int> insertMatricula(MatriculaModel matricula) async {
    final db = await AppDatabase.getDatabase();
    return await db.insert(_tabela, matricula.toMap());
  }

  /// Retorna todas as matrículas de um usuário específico
  Future<List<MatriculaModel>> getMatriculasPorUsuario(String idUsuario) async {
    final db = await AppDatabase.getDatabase();
    final List<Map<String, dynamic>> resultado = await db.query(
      _tabela,
      where: 'id_usuario = ?',
      whereArgs: [idUsuario],
    );
    return resultado.map((map) => MatriculaModel.fromMap(map)).toList();
  }

  /// Retorna todas as matrículas
  Future<List<MatriculaModel>> getTodasMatriculas() async {
    final db = await AppDatabase.getDatabase();
    final List<Map<String, dynamic>> resultado = await db.query(_tabela);
    return resultado.map((map) => MatriculaModel.fromMap(map)).toList();
  }

  /// Deleta uma matrícula pelo ID
  Future<int> deleteMatricula(int id) async {
    final db = await AppDatabase.getDatabase();
    return await db.delete(_tabela, where: 'id = ?', whereArgs: [id]);
  }

  /// Verifica se já existe matrícula de um usuário em determinado estudo
  Future<bool> existsMatricula(String idUsuario, int idEstudoBiblico) async {
    final db = await AppDatabase.getDatabase();
    final resultado = await db.query(
      _tabela,
      where: 'id_usuario = ? AND id_estudo_biblico = ?',
      whereArgs: [idUsuario, idEstudoBiblico],
    );
    return resultado.isNotEmpty;
  }

  //// Retorna a primeira matrícula de um usuário
  Future<MatriculaModel?> getPrimeiraMatriculaPorUsuario(
    String idUsuario,
  ) async {
    final db = await AppDatabase.getDatabase();
    final resultado = await db.query(
      _tabela,
      where: 'id_usuario = ?',
      whereArgs: [idUsuario],
      orderBy: 'data_matricula DESC',
      limit: 1,
    );

    if (resultado.isNotEmpty) {
      return MatriculaModel.fromMap(resultado.first);
    }

    return null;
  }
}
