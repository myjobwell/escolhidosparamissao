class Licao {
  final int id;
  final String nome;
  final int idEstudo;

  Licao({required this.id, required this.nome, required this.idEstudo});

  factory Licao.fromMap(Map<String, dynamic> map) {
    return Licao(
      id: map['idLicao'],
      nome: map['licao'],
      idEstudo: map['idEstudo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'idLicao': id, 'licao': nome, 'idEstudo': idEstudo};
  }
}
