class Igreja {
  final String id;
  final String nome;
  final String associacaoId;
  final String associacaoNome;
  final String distritoId;
  final String distritoNome;

  Igreja({
    required this.id,
    required this.nome,
    required this.associacaoId,
    required this.associacaoNome,
    required this.distritoId,
    required this.distritoNome,
  });

  factory Igreja.fromMap(String id, Map<String, dynamic> map) {
    return Igreja(
      id: id,
      nome: map['nome'] ?? '',
      associacaoId: map['associacaoId'] ?? '',
      associacaoNome: map['associacaoNome'] ?? '',
      distritoId: map['distritoId'] ?? '',
      distritoNome: map['distritoNome'] ?? '',
    );
  }
}
