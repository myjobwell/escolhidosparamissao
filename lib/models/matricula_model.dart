class MatriculaModel {
  final int? id;
  final String idUsuario;
  final int idEstudoBiblico;
  final String? dataMatricula;

  MatriculaModel({
    this.id,
    required this.idUsuario,
    required this.idEstudoBiblico,
    this.dataMatricula,
  });

  /// Converte um Map do SQLite para o modelo Dart
  factory MatriculaModel.fromMap(Map<String, dynamic> map) {
    return MatriculaModel(
      id: map['id'],
      idUsuario: map['id_usuario'],
      idEstudoBiblico: map['id_estudo_biblico'],
      dataMatricula: map['data_matricula'],
    );
  }

  /// Converte o modelo Dart para um Map que pode ser inserido no SQLite
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'id_usuario': idUsuario,
      'id_estudo_biblico': idEstudoBiblico,
      'data_matricula': dataMatricula,
    };
  }
}
