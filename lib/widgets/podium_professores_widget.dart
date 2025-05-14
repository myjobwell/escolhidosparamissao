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

class PodiumProfessores extends StatelessWidget {
  final List<Professor> professores;
  final int offset;
  final VoidCallback? onLoadMore;
  final bool isLoading;
  final bool hasMore;

  final List<String> emojisMasculinos = const [
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

  final List<String> emojisFemininos = const [
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

  PodiumProfessores({
    super.key,
    required this.professores,
    this.offset = 4,
    this.onLoadMore,
    required this.isLoading,
    required this.hasMore,
  });

  String _getEmoji(String sexo, int index) {
    return sexo == 'feminino'
        ? emojisFemininos[index % emojisFemininos.length]
        : emojisMasculinos[index % emojisMasculinos.length];
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.pixels >=
                notification.metrics.maxScrollExtent - 100 &&
            !isLoading &&
            hasMore) {
          onLoadMore?.call();
        }
        return false;
      },
      child: ListView.builder(
        itemCount: professores.length + (isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= professores.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final professor = professores[index];
          final posicao = index + offset;
          final emoji = _getEmoji(professor.sexo, index);

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
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
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${professor.pontos} pontos',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/* import 'package:flutter/material.dart';

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
  final int offset;
  final Future<void> Function() onLoadMore;
  final bool isLoading;
  final bool hasMore;

  const PodiumProfessores({
    Key? key,
    required this.professores,
    required this.onLoadMore,
    required this.isLoading,
    required this.hasMore,
    this.offset = 4,
  }) : super(key: key);

  @override
  _PodiumProfessoresState createState() => _PodiumProfessoresState();
}

class _PodiumProfessoresState extends State<PodiumProfessores> {
  final ScrollController _scrollController = ScrollController();

  final List<String> emojisMasculinos = const [
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

  final List<String> emojisFemininos = const [
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
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !widget.isLoading &&
        widget.hasMore) {
      widget.onLoadMore();
    }
  }

  String _getEmoji(String sexo, int index) {
    return sexo == 'feminino'
        ? emojisFemininos[index % emojisFemininos.length]
        : emojisMasculinos[index % emojisMasculinos.length];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount:
          widget.hasMore
              ? widget.professores.length + 1
              : widget.professores.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        if (index >= widget.professores.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final professor = widget.professores[index];
        final posicao = index + widget.offset;
        final emoji = _getEmoji(professor.sexo, index);

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
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
                '${professor.pontos} pontos',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }
} */

/* import 'package:flutter/material.dart';

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

class PodiumProfessores extends StatelessWidget {
  final List<Professor> professores;
  final int offset; // começa em 4
  final List<String> emojisMasculinos = const [
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

  final List<String> emojisFemininos = const [
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

  PodiumProfessores({Key? key, required this.professores, this.offset = 4})
    : super(key: key);

  String _getEmoji(String sexo, int index) {
    return sexo == 'feminino'
        ? emojisFemininos[index % emojisFemininos.length]
        : emojisMasculinos[index % emojisMasculinos.length];
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: professores.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final professor = professores[index];
        final posicao = index + offset;
        final emoji = _getEmoji(professor.sexo, index);

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
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
} */
