class MatriculaModel {
  final int? id;
  final String idUsuario;
  final int idEstudoBiblico;
  final String? dataMatricula;
  final int sincronizado;

  MatriculaModel({
    this.id,
    required this.idUsuario,
    required this.idEstudoBiblico,
    this.dataMatricula,
    this.sincronizado = 0, // Valor padrão como não sincronizado
  });

  factory MatriculaModel.fromMap(Map<String, dynamic> map) {
    return MatriculaModel(
      id: map['id'],
      idUsuario: map['id_usuario'],
      idEstudoBiblico: map['id_estudo_biblico'],
      dataMatricula: map['data_matricula'],
      sincronizado: map['sincronizado'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'id_usuario': idUsuario,
      'id_estudo_biblico': idEstudoBiblico,
      'data_matricula': dataMatricula,
      'sincronizado': sincronizado,
    };
  }
}
