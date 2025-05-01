class Licao {
  final int id;
  final String nome;
  final int estudoId;

  Licao({required this.id, required this.nome, required this.estudoId});

  factory Licao.fromMap(Map<String, dynamic> map) {
    return Licao(
      id: map['idLicao'],
      nome: map['nome'],
      estudoId: map['idEstudo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'idLicao': id, 'licao': nome, 'idEstudo': estudoId};
  }
}
