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

      List<Map<String, dynamic>> ranking =
          snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;

            final rawNome = (data['nome'] ?? '').toString().trim();
            final partes =
                rawNome
                    .split(RegExp(r'\s+'))
                    .where((p) => p.isNotEmpty)
                    .toList();
            final nomeFormatado =
                partes.length >= 2
                    ? '${partes.first} ${partes.last}'
                    : partes.isNotEmpty
                    ? partes.first
                    : 'Participante';

            return {
              'nome': nomeFormatado,
              'totalPontos': data['totalPontos'] ?? 0,
              'sexo': data['sexo'] ?? 'masculino',
              'igrejaNome': data['igrejaNome'] ?? '',
            };
          }).toList();

      while (ranking.length < 3) {
        ranking.add({
          'nome': 'Participante',
          'totalPontos': 0,
          'sexo': 'masculino',
          'igrejaNome': '',
        });
      }

      return ranking;
    } catch (e) {
      print('Erro ao buscar ranking: $e');
      return List.generate(
        3,
        (_) => {
          'nome': 'Participante',
          'totalPontos': 0,
          'sexo': 'masculino',
          'igrejaNome': '',
        },
      );
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

        while (ranking.length < 3) {
          ranking.add({
            'nome': 'Participante',
            'totalPontos': 0,
            'sexo': 'masculino',
            'igrejaNome': '',
          });
        }

        return Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Center(
            child: SizedBox(
              width: 345,
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
                    left: 0,
                    bottom: 265,
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/hex_coroa_dourada.svg',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(height: 4),
                        _buildCompetitor(
                          nome: ranking[1]['nome'],
                          pontos: ranking[1]['totalPontos'],
                          emoji: getEmoji(ranking[1]['sexo'], 1),
                          igrejaNome: ranking[1]['igrejaNome'],
                        ),
                      ],
                    ),
                  ),

                  // 1º lugar
                  Positioned(
                    left: 110,
                    bottom: 290,
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/hex_coroa_dourada.svg',
                          width: 32,
                          height: 32,
                        ),
                        const SizedBox(height: 4),
                        _buildCompetitor(
                          nome: ranking[0]['nome'],
                          pontos: ranking[0]['totalPontos'],
                          emoji: getEmoji(ranking[0]['sexo'], 0),
                          igrejaNome: ranking[0]['igrejaNome'],
                        ),
                      ],
                    ),
                  ),

                  // 3º lugar
                  Positioned(
                    right: 0,
                    bottom: 235,
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/hex_coroa_dourada.svg',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(height: 4),
                        _buildCompetitor(
                          nome: ranking[2]['nome'],
                          pontos: ranking[2]['totalPontos'],
                          emoji: getEmoji(ranking[2]['sexo'], 2),
                          igrejaNome: ranking[2]['igrejaNome'],
                        ),
                      ],
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
    return SizedBox(
      width: 125,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 22,
            child: Text(emoji, style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(height: 2),
          SizedBox(
            height: 16,
            child: Text(
              nome,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            height: 30,
            child: Text(
              igrejaNome.isNotEmpty ? igrejaNome : '---',
              style: const TextStyle(fontSize: 12, color: Colors.white70),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
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
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
