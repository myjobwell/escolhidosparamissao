class Conteudo {
  final int idConteudo;
  final String pergunta;
  final String resposta;
  final int idLicao;

  Conteudo({
    required this.idConteudo,
    required this.pergunta,
    required this.resposta,
    required this.idLicao,
  });

  factory Conteudo.fromMap(Map<String, dynamic> map) {
    return Conteudo(
      idConteudo: map['idConteudo'],
      pergunta: map['pergunta'],
      resposta: map['resposta'],
      idLicao: map['idLicao'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idConteudo': idConteudo,
      'pergunta': pergunta,
      'resposta': resposta,
      'idLicao': idLicao,
    };
  }
}
