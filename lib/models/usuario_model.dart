class Usuario {
  final String id;
  final String nome;
  final String cpf;
  final String sexo;
  final String telefone;
  final String email;
  final String nascimento;
  final String tipoUsuario;
  final int divisaoId;
  final String divisaoNome;
  final int uniaoId;
  final String uniaoNome;
  final int associacaoId;
  final String associacaoNome;
  final int distritoId;
  final String distritoNome;
  final String igrejaId;
  final String igrejaNome;
  final bool sincronizado;
  final String? idProfessor;

  Usuario({
    required this.id,
    required this.nome,
    required this.cpf,
    required this.sexo,
    required this.telefone,
    required this.email,
    required this.nascimento,
    required this.tipoUsuario,
    required this.divisaoId,
    required this.divisaoNome,
    required this.uniaoId,
    required this.uniaoNome,
    required this.associacaoId,
    required this.associacaoNome,
    required this.distritoId,
    required this.distritoNome,
    required this.igrejaId,
    required this.igrejaNome,
    required this.sincronizado,
    this.idProfessor,
  });

  factory Usuario.fromMap(Map<String, dynamic> data, String documentId) {
    return Usuario(
      id: documentId,
      nome: data['nome']?.toString() ?? '',
      cpf: data['cpf']?.toString() ?? '',
      sexo: data['sexo']?.toString() ?? '',
      telefone: data['telefone']?.toString() ?? '',
      email: data['email']?.toString() ?? '',
      nascimento: data['nascimento']?.toString() ?? '',
      tipoUsuario: data['tipo_usuario']?.toString() ?? '',
      divisaoId: data['divisaoId'] as int,
      divisaoNome: data['divisaoNome']?.toString() ?? '',
      uniaoId: data['uniaoId'] as int,
      uniaoNome: data['uniaoNome']?.toString() ?? '',
      associacaoId: data['associacaoId'] as int,
      associacaoNome: data['associacaoNome']?.toString() ?? '',
      distritoId: data['distritoId'] as int,
      distritoNome: data['distritoNome']?.toString() ?? '',
      igrejaId: data['igrejaId']?.toString() ?? '',
      igrejaNome: data['igrejaNome']?.toString() ?? '',
      sincronizado: (data['sincronizado'] == 1 || data['sincronizado'] == true),
      idProfessor: data['id_professor']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id, // <-- este campo estava faltando
      'nome': nome,
      'cpf': cpf,
      'sexo': sexo,
      'telefone': telefone,
      'email': email,
      'nascimento': nascimento,
      'tipo_usuario': tipoUsuario,
      'divisaoId': divisaoId,
      'divisaoNome': divisaoNome,
      'uniaoId': uniaoId,
      'uniaoNome': uniaoNome,
      'associacaoId': associacaoId,
      'associacaoNome': associacaoNome,
      'distritoId': distritoId,
      'distritoNome': distritoNome,
      'igrejaId': igrejaId,
      'igrejaNome': igrejaNome,
      'sincronizado': sincronizado ? 1 : 0,
      'id_professor': idProfessor,
    };
  }
}
