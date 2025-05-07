import 'package:flutter/material.dart';

class ResumoPainelProfessor extends StatelessWidget {
  final int totalEstudos;
  final int totalPontos;
  final int ranking;

  const ResumoPainelProfessor({
    super.key,
    required this.totalEstudos,
    required this.totalPontos,
    required this.ranking,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08), // sombra bem suave
            blurRadius: 6,
            offset: const Offset(0, 4), // deslocamento vertical
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildItem(Icons.star_border, 'ALUNOS', totalEstudos.toString()),
          _verticalDivider(),
          _buildItem(Icons.menu_book, 'PONTOS', totalPontos.toString()),
          _verticalDivider(),
          _buildItem(Icons.emoji_events, 'RANKING', '#$ranking'),
        ],
      ),
    );
  }

  Widget _buildItem(IconData icon, String title, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color(0xFF3D3D4C)),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFFB3B2C9),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF3D3D4C),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _verticalDivider() {
    return Container(
      width: 1,
      height: 48,
      color: const Color(0xFFDFDFDF),
      margin: const EdgeInsets.symmetric(horizontal: 12),
    );
  }
}
