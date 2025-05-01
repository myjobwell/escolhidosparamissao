import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widgets/layout_page.dart';
import '../../pages/alunos/adicionar_alunos_screen.dart';

class AlunosPage extends StatelessWidget {
  const AlunosPage({super.key});

  void _navegarParaAdicionarAluno(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AdicionarAlunoPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final alunos = [
      {
        'posicao': 1,
        'nome': 'Adison Press',
        'pontos': 2569,
        'avatar': '👩',
        'iconCoroa': 'assets/icons/hex_coroa_dourada.svg',
      },
      {
        'posicao': 2,
        'nome': 'Ruben Geidt',
        'pontos': 1469,
        'avatar': '👨',
        'iconCoroa': 'assets/icons/hex_coroa_dourada.svg',
      },
      {
        'posicao': 3,
        'nome': 'Jakob Levin',
        'pontos': 1053,
        'avatar': '👨🏾',
        'iconCoroa': 'assets/icons/hex_coroa_verde.svg',
      },
      {
        'posicao': 4,
        'nome': 'Madelyn Dias',
        'pontos': 590,
        'avatar': '👩‍🎓',
        'iconCoroa': 'assets/icons/hex_coroa_cinza.svg',
      },
      {
        'posicao': 5,
        'nome': 'Zain Vaccaro',
        'pontos': 448,
        'avatar': '👨🏿‍🏫',
        'iconCoroa': 'assets/icons/hex_coroa_cinza.svg',
      },
    ];

    return BasePage(
      titulo: 'Meus Alunos',
      isLoading: false,
      exibirBotaoVoltar: true,
      centralizarTitulo: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () => _navegarParaAdicionarAluno(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.person_add_alt_1, size: 24, color: Colors.black),
                SizedBox(width: 8),
                Text(
                  'Aluno',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ...alunos.map((aluno) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AlunoItem(
                posicao: aluno['posicao'] as int,
                nome: aluno['nome'] as String,
                pontos: aluno['pontos'] as int,
                avatar: aluno['avatar'] as String,
                iconCoroa: aluno['iconCoroa'] as String?,
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class AlunoItem extends StatelessWidget {
  final int posicao;
  final String nome;
  final int pontos;
  final String avatar;
  final String? iconCoroa;

  const AlunoItem({
    super.key,
    required this.posicao,
    required this.nome,
    required this.pontos,
    required this.avatar,
    this.iconCoroa,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F3FB),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 16,
            child: Text(
              posicao.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            backgroundColor: Colors.pink.shade100,
            radius: 24,
            child: Text(avatar, style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nome,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '$pontos points',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          if (iconCoroa != null)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: SvgPicture.asset(iconCoroa!, height: 24, width: 24),
            ),
        ],
      ),
    );
  }
}
