class EstudoBiblico {
  final int id;
  final String nome;

  EstudoBiblico({required this.id, required this.nome});

  factory EstudoBiblico.fromMap(Map<String, dynamic> map) {
    return EstudoBiblico(id: map['id'], nome: map['nome']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'nome': nome};
  }
}
