import 'package:cloud_firestore/cloud_firestore.dart';

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
