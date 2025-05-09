import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Podium extends StatefulWidget {
  const Podium({Key? key}) : super(key: key);

  @override
  State<Podium> createState() => _PodiumState();
}

class _PodiumState extends State<Podium> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Future<List<Map<String, dynamic>>> _rankingFuture;

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

  String getEmoji(String sexo, int index) {
    return sexo.toLowerCase() == 'feminino'
        ? emojisFemininos[index % emojisFemininos.length]
        : emojisMasculinos[index % emojisMasculinos.length];
  }

  Future<List<Map<String, dynamic>>> getTop3Rankings() async {
    try {
      QuerySnapshot snapshot =
          await _firestore
              .collection('ranking')
              .orderBy('totalPontos', descending: true)
              .limit(3)
              .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'nome': data['nome'] ?? '',
          'totalPontos': data['totalPontos'] ?? 0,
          'sexo': data['sexo'] ?? 'masculino',
          'igrejaNome': data['igrejaNome'] ?? '',
        };
      }).toList();
    } catch (e) {
      print('Erro ao buscar ranking: $e');
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    _rankingFuture = getTop3Rankings();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _rankingFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        List<Map<String, dynamic>> ranking = snapshot.data ?? [];

        // Preenche até ter 3 posições
        while (ranking.length < 3) {
          ranking.add({
            'nome': '',
            'totalPontos': 0,
            'sexo': 'masculino',
            'igrejaNome': '',
          });
        }

        return Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Center(
            child: SizedBox(
              width: 300,
              height: 340,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/imgs/podium.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  // 2º lugar
                  Positioned(
                    left: 10,
                    bottom: 265,
                    child: _buildCompetitor(
                      nome: ranking[1]['nome'],
                      pontos: ranking[1]['totalPontos'],
                      emoji: getEmoji(ranking[1]['sexo'], 1),
                      igrejaNome: ranking[1]['igrejaNome'],
                    ),
                  ),
                  // 1º lugar
                  Positioned(
                    left: 105,
                    bottom: 270,
                    child: _buildCompetitor(
                      nome: ranking[0]['nome'],
                      pontos: ranking[0]['totalPontos'],
                      emoji: getEmoji(ranking[0]['sexo'], 0),
                      igrejaNome: ranking[0]['igrejaNome'],
                    ),
                  ),
                  // 3º lugar
                  Positioned(
                    right: 10,
                    bottom: 235,
                    child: _buildCompetitor(
                      nome: ranking[2]['nome'],
                      pontos: ranking[2]['totalPontos'],
                      emoji: getEmoji(ranking[2]['sexo'], 2),
                      igrejaNome: ranking[2]['igrejaNome'],
                    ),
                  ),
                  // Coroas
                  Positioned(
                    left: 37,
                    bottom: 370,
                    child: SvgPicture.asset(
                      'assets/icons/hex_coroa_dourada.svg',
                      width: 24,
                      height: 24,
                    ),
                  ),
                  Positioned(
                    left: 132,
                    bottom: 373,
                    child: SvgPicture.asset(
                      'assets/icons/hex_coroa_dourada.svg',
                      width: 32,
                      height: 32,
                    ),
                  ),
                  Positioned(
                    right: 38,
                    bottom: 340,
                    child: SvgPicture.asset(
                      'assets/icons/hex_coroa_dourada.svg',
                      width: 24,
                      height: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompetitor({
    required String nome,
    required int pontos,
    required String emoji,
    required String igrejaNome,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          child: Text(emoji, style: const TextStyle(fontSize: 20)),
        ),
        const SizedBox(height: 4),
        Text(
          nome.isNotEmpty ? nome : '---',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 0),
        Text(
          igrejaNome.isNotEmpty ? igrejaNome : '---',
          style: const TextStyle(fontSize: 10, color: Colors.white70),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 122, 79, 202),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$pontos Pts',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ],
    );
  }
}




/* import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Podium extends StatelessWidget {
  final List<String> nomes;
  final List<int> pontos;
  final List<String> sexos;
  final List<String> distritos;

  Podium({
    Key? key,
    required this.nomes,
    required this.pontos,
    required this.sexos,
    required this.distritos,
  }) : super(key: key);

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

  String getEmoji(String sexo, int index) {
    return sexo == 'feminino'
        ? emojisFemininos[index % emojisFemininos.length]
        : emojisMasculinos[index % emojisMasculinos.length];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Center(
        child: SizedBox(
          width: 300,
          height: 340,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/imgs/podium.png',
                  fit: BoxFit.contain,
                ),
              ),

              // 2º lugar
              Positioned(
                left: 10,
                bottom: 265,
                child: _buildCompetitor(
                  nome: nomes[1],
                  pontos: pontos[1],
                  emoji: getEmoji(sexos[1], 1),
                  distrito: distritos[1],
                ),
              ),

              // 1º lugar
              Positioned(
                left: 105,
                bottom: 270,
                child: _buildCompetitor(
                  nome: nomes[0],
                  pontos: pontos[0],
                  emoji: getEmoji(sexos[0], 0),
                  distrito: distritos[0],
                ),
              ),

              // 3º lugar
              Positioned(
                right: 10,
                bottom: 235,
                child: _buildCompetitor(
                  nome: nomes[2],
                  pontos: pontos[2],
                  emoji: getEmoji(sexos[2], 2),
                  distrito: distritos[2],
                ),
              ),

              // 🔽 CROWNS MOVED TO BOTTOM OF STACK TO STAY ABOVE EMOJIS

              // Coroa do 2º lugar
              Positioned(
                left: 37,
                bottom: 370,
                child: SvgPicture.asset(
                  'assets/icons/hex_coroa_dourada.svg',
                  width: 24,
                  height: 24,
                ),
              ),

              // Coroa do 1º lugar
              Positioned(
                left: 132,
                bottom: 373,
                child: SvgPicture.asset(
                  'assets/icons/hex_coroa_dourada.svg',
                  width: 32,
                  height: 32,
                ),
              ),

              // Coroa do 3º lugar
              Positioned(
                right: 38,
                bottom: 340,
                child: SvgPicture.asset(
                  'assets/icons/hex_coroa_dourada.svg',
                  width: 24,
                  height: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompetitor({
    required String nome,
    required int pontos,
    required String emoji,
    required String distrito,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          child: Text(emoji, style: const TextStyle(fontSize: 20)),
        ),
        const SizedBox(height: 4),
        Text(
          nome,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 0),
        Text(
          distrito,
          style: const TextStyle(fontSize: 10, color: Colors.white70),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 122, 79, 202),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$pontos Pts',
            style: const TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
 */



/* import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Podium extends StatelessWidget {
  final List<String> nomes;
  final List<int> pontos;
  final List<String> sexos;
  final List<String> distritos;

  Podium({
    Key? key,
    required this.nomes,
    required this.pontos,
    required this.sexos,
    required this.distritos,
  }) : super(key: key);

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

  String getEmoji(String sexo, int index) {
    return sexo == 'feminino'
        ? emojisFemininos[index % emojisFemininos.length]
        : emojisMasculinos[index % emojisMasculinos.length];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Center(
        child: SizedBox(
          width: 300,
          height: 340,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/imgs/podium.png',
                  fit: BoxFit.contain,
                ),
              ),

              // 2º lugar - Esquerda
              Positioned(
                left: 10,
                bottom: 265,
                child: _buildCompetitor(
                  nome: nomes[1],
                  pontos: pontos[1],
                  emoji: getEmoji(sexos[1], 1),
                  distrito: distritos[1],
                ),
              ),

              // 1º lugar - Centro
              Positioned(
                left: 105,
                bottom: 295,
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/hex_coroa_dourada.svg',
                      width: 32,
                      height: 32,
                    ),
                    _buildCompetitor(
                      nome: nomes[0],
                      pontos: pontos[0],
                      emoji: getEmoji(sexos[0], 0),
                      distrito: distritos[0],
                    ),
                  ],
                ),
              ),

              // 3º lugar - Direita
              Positioned(
                right: 10,
                bottom: 235,
                child: _buildCompetitor(
                  nome: nomes[2],
                  pontos: pontos[2],
                  emoji: getEmoji(sexos[2], 2),
                  distrito: distritos[2],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompetitor({
    required String nome,
    required int pontos,
    required String emoji,
    required String distrito,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          child: Text(emoji, style: const TextStyle(fontSize: 20)),
        ),
        const SizedBox(height: 4),
        Text(
          nome,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 0),
        Text(
          distrito,
          style: const TextStyle(fontSize: 10, color: Colors.white70),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$pontos QP',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ],
    );
  }
}
 */