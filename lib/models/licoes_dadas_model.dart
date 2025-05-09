class LicoesDadas {
  final int? id;
  final String idUsuario;
  final int idLicao;
  final int idEstudoBiblico;
  final int sincronizado;
  final bool checado;
  final String? idProfessor;
  final String? dataUpdate;

  LicoesDadas({
    this.id,
    required this.idUsuario,
    required this.idLicao,
    required this.idEstudoBiblico,
    this.sincronizado = 0,
    this.checado = false,
    this.idProfessor,
    this.dataUpdate,
  });

  factory LicoesDadas.fromMap(Map<String, dynamic> map) {
    return LicoesDadas(
      id: map['id'],
      idUsuario: map['id_usuario'],
      idLicao: map['idLicao'],
      idEstudoBiblico: map['id_estudo_biblico'],
      sincronizado: map['sincronizado'] ?? 0,
      checado: map['checado'] == 1,
      idProfessor: map['id_professor'],
      dataUpdate: map['data_update'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_usuario': idUsuario,
      'idLicao': idLicao,
      'id_estudo_biblico': idEstudoBiblico,
      'sincronizado': sincronizado,
      'checado': checado ? 1 : 0,
      'id_professor': idProfessor,
      'data_update': dataUpdate,
    };
  }

  LicoesDadas copyWith({
    int? id,
    String? idUsuario,
    int? idLicao,
    int? idEstudoBiblico,
    int? sincronizado,
    bool? checado,
    String? idProfessor,
    String? dataUpdate,
  }) {
    return LicoesDadas(
      id: id ?? this.id,
      idUsuario: idUsuario ?? this.idUsuario,
      idLicao: idLicao ?? this.idLicao,
      idEstudoBiblico: idEstudoBiblico ?? this.idEstudoBiblico,
      sincronizado: sincronizado ?? this.sincronizado,
      checado: checado ?? this.checado,
      idProfessor: idProfessor ?? this.idProfessor,
      dataUpdate: dataUpdate ?? this.dataUpdate,
    );
  }
}



/* class LicoesDadas {
  final int? id;
  final String idUsuario;
  final int idLicao;
  final int idEstudoBiblico;
  final int sincronizado;
  final bool checado;

  LicoesDadas({
    this.id,
    required this.idUsuario,
    required this.idLicao,
    required this.idEstudoBiblico,
    this.sincronizado = 0,
    this.checado = false,
  });

  factory LicoesDadas.fromMap(Map<String, dynamic> map) {
    return LicoesDadas(
      id: map['id'],
      idUsuario: map['id_usuario'],
      idLicao: map['idLicao'],
      idEstudoBiblico: map['id_estudo_biblico'],
      sincronizado: map['sincronizado'] ?? 0,
      checado: map['checado'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_usuario': idUsuario,
      'idLicao': idLicao,
      'id_estudo_biblico': idEstudoBiblico,
      'sincronizado': sincronizado,
      'checado': checado ? 1 : 0,
    };
  }

  LicoesDadas copyWith({
    int? id,
    String? idUsuario,
    int? idLicao,
    int? idEstudoBiblico,
    int? sincronizado,
    bool? checado,
  }) {
    return LicoesDadas(
      id: id ?? this.id,
      idUsuario: idUsuario ?? this.idUsuario,
      idLicao: idLicao ?? this.idLicao,
      idEstudoBiblico: idEstudoBiblico ?? this.idEstudoBiblico,
      sincronizado: sincronizado ?? this.sincronizado,
      checado: checado ?? this.checado,
    );
  }
}
 */