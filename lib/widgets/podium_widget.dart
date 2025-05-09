import 'package:flutter/material.dart';
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