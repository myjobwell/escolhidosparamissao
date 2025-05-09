import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class Professor {
  final String nome;
  final String distrito;
  final int pontos;
  final String sexo;

  Professor({
    required this.nome,
    required this.distrito,
    required this.pontos,
    required this.sexo,
  });
}

class PodiumProfessores extends StatefulWidget {
  final List<Professor> professores;

  const PodiumProfessores({Key? key, required this.professores})
    : super(key: key);

  @override
  State<PodiumProfessores> createState() => _PodiumProfessoresState();
}

class _PodiumProfessoresState extends State<PodiumProfessores> {
  final ScrollController _scrollController = ScrollController();
  final int _pageSize = 7;
  int _loadedItems = 0;
  List<Professor> _displayedProfessores = [];

  final List<String> emojisMasculinos = [
    '👨‍💼',
    '👨‍🔧',
    '👨‍🏫',
    '👨‍🎓',
    '👨‍🚀',
    '👨‍⚕️',
    '👨‍🎨',
    '👨‍🍳',
    '👨‍✈️',
    '👨‍🌾',
  ];

  final List<String> emojisFemininos = [
    '👩‍💼',
    '👩‍🔧',
    '👩‍🏫',
    '👩‍🎓',
    '👩‍🚀',
    '👩‍⚕️',
    '👩‍🎨',
    '👩‍🍳',
    '👩‍✈️',
    '👩‍🌾',
  ];

  @override
  void initState() {
    super.initState();
    _loadMore();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMore() {
    final nextItems =
        widget.professores.skip(_loadedItems).take(_pageSize).toList();
    setState(() {
      _displayedProfessores.addAll(nextItems);
      _loadedItems = _displayedProfessores.length;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (_loadedItems < widget.professores.length) {
        _loadMore();
      }
    }
  }

  String _getEmoji(String sexo, int index) {
    return sexo == 'feminino'
        ? emojisFemininos[index % emojisFemininos.length]
        : emojisMasculinos[index % emojisMasculinos.length];
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _displayedProfessores.length,
      itemBuilder: (context, index) {
        final professor = _displayedProfessores[index];
        final posicao = index + 4; // começa a contar do 4
        final emoji = _getEmoji(professor.sexo, index);

        return Container(
          margin: const EdgeInsets.only(bottom: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: const Color(0xFFF0E6FF),
                child: Text(
                  '$posicao',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              CircleAvatar(
                radius: 16,
                backgroundColor:
                    professor.sexo == 'feminino'
                        ? Colors.pink.shade100
                        : Colors.blue.shade100,
                child: Text(emoji, style: const TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      professor.nome,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      professor.distrito,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Text(
                '${professor.pontos} points',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }
}
