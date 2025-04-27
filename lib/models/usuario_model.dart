class Usuario {
  final String? id;
  final String nome;
  final String cpf;
  final String sexo;
  final String telefone;
  final String email;
  final String nascimento; // formato yyyy-MM-dd ou ISO 8601
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
  final bool sincronizado; // ✅ Adicionado campo para controle de sincronização

  Usuario({
    this.id,
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
    required this.sincronizado, // novo campo obrigatório
  });

  // Função para criar um Usuario a partir de um Map (ex: dados vindos do SQLite ou Firebase)
  factory Usuario.fromMap(Map<String, dynamic> data, String? documentId) {
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
    );
  }

  // Função para converter o Usuario em Map (para salvar no SQLite ou Firebase)
  Map<String, dynamic> toMap() {
    return {
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
      'sincronizado': sincronizado ? 1 : 0, // salva como inteiro no SQLite
    };
  }
}


/* class Usuario {
  final String? id;
  final String nome;
  final String cpf;
  final String sexo;
  final String telefone;
  final String email;
  final String nascimento; // formato yyyy-MM-dd ou ISO 8601
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

  Usuario({
    this.id,
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
  });

  factory Usuario.fromMap(Map<String, dynamic> data, String? documentId) {
    return Usuario(
      id: documentId,
      nome: data['nome'],
      cpf: data['cpf'],
      sexo: data['sexo'],
      telefone: data['telefone'],
      email: data['email'],
      nascimento: data['nascimento'],
      tipoUsuario: data['tipo_usuario'],
      divisaoId: data['divisaoId'],
      divisaoNome: data['divisaoNome'],
      uniaoId: data['uniaoId'],
      uniaoNome: data['uniaoNome'],
      associacaoId: data['associacaoId'],
      associacaoNome: data['associacaoNome'],
      distritoId: data['distritoId'],
      distritoNome: data['distritoNome'],
      igrejaId: data['igrejaId'],
      igrejaNome: data['igrejaNome'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
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
    };
  }
}

/* import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  final String? id;
  final String nome;
  final String cpf;
  final DateTime dataNascimento;
  final String distrito;
  final String igrejaId;
  final String nomeIgreja;
  final String sexo;
  final int telefone;
  final String tipoUsuario;
  final String ativo;

  Usuario({
    this.id,
    required this.nome,
    required this.cpf,
    required this.dataNascimento,
    required this.distrito,
    required this.igrejaId,
    required this.nomeIgreja,
    required this.sexo,
    required this.telefone,
    required this.tipoUsuario,
    required this.ativo,
  });

  factory Usuario.fromMap(Map<String, dynamic> data, String documentId) {
    return Usuario(
      id: documentId,
      nome: data['nome'],
      cpf: data['cpf'],
      dataNascimento: (data['dataNascimento'] as Timestamp).toDate(),
      distrito: data['distrito'],
      igrejaId: data['igrejaId'],
      nomeIgreja: data['nomeIgreja'],
      sexo: data['sexo'],
      telefone: data['telefone'],
      tipoUsuario: data['tipoUsuario'],
      ativo: data['ativo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'cpf': cpf,
      'dataNascimento': dataNascimento,
      'distrito': distrito,
      'igrejaId': igrejaId,
      'nomeIgreja': nomeIgreja,
      'sexo': sexo,
      'telefone': telefone,
      'tipoUsuario': tipoUsuario,
      'ativo': ativo,
    };
  }
}
 */
 */