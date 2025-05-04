import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widgets/layout_page.dart';
import '../../pages/alunos/adicionar_alunos_screen.dart';
import '../../models/usuario_model.dart';
import '../../databases/usuario_dao.dart';
import '../../core/global.dart';
import '../../pages/alunos/aluno_painel_screen.dart';
import '../../pages/alunos/matricula_aluno_screen.dart';
import '../../models/matricula_model.dart';
import '../../databases/matriculas_dao.dart';
import '../../databases/licoes_dadas_dao.dart';

class AlunosPage extends StatefulWidget {
  const AlunosPage({super.key});

  @override
  State<AlunosPage> createState() => _AlunosPageState();
}

class _AlunosPageState extends State<AlunosPage> {
  List<Usuario> _alunos = [];
  Map<String, int> _pontosPorAluno = {};
  bool _isLoading = true;

  final List<String> emojisMasculinos = [
    '👨',
    '👨🏻',
    '👨🏼',
    '👨🏽',
    '👨🏾',
    '👨🏿',
    '🧔',
    '🧔🏻',
    '🧔🏽',
    '🧔🏾',
  ];

  final List<String> emojisFemininos = [
    '👩',
    '👩🏻',
    '👩🏼',
    '👩🏽',
    '👩🏾',
    '👩🏿',
    '👩‍🎓',
    '👩‍🏫',
    '👩‍⚕️',
    '👩‍💼',
  ];

  @override
  void initState() {
    super.initState();
    _carregarAlunos();
  }

  Future<void> _carregarAlunos() async {
    setState(() => _isLoading = true);
    final alunos = await DbUsuario.buscarUsuariosPorProfessor(cpfLogado!);

    final Map<String, int> pontosTemp = {};

    for (final aluno in alunos) {
      final matricula = await MatriculaDao().getPrimeiraMatriculaPorUsuario(
        aluno.id,
      );
      if (matricula != null) {
        final status = await LicoesDadasDao().buscarStatusLicoesChecadas(
          idUsuario: aluno.id,
          idEstudoBiblico: matricula.idEstudoBiblico,
        );
        final totalConcluidas = status.values.where((v) => v == 1).length;
        pontosTemp[aluno.id] = totalConcluidas;
      } else {
        pontosTemp[aluno.id] = 0;
      }
    }

    setState(() {
      _alunos = alunos;
      _pontosPorAluno = pontosTemp;
      _isLoading = false;
    });
  }

  void _navegarParaAdicionarAluno(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AdicionarAlunoPage()),
    ).then((_) {
      _carregarAlunos();
    });
  }

  String sortearEmoji(String sexo) {
    final isFeminino = sexo.toLowerCase().contains('fem');
    final lista = isFeminino ? emojisFemininos : emojisMasculinos;
    lista.shuffle();
    return lista.first;
  }

  /*
  Future<void> verificarMatriculaAluno(
    BuildContext context,
    Usuario aluno,
  ) async {
    final dao = MatriculaDao();
    final matricula = await dao.getPrimeiraMatriculaPorUsuario(aluno.id);

    if (matricula != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => AlunoPainel(
                idAluno: aluno.id,
                idEstudo: matricula.idEstudoBiblico,
                nomeAluno: aluno.nome,
              ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => MatriculaAlunoScreen(
                idAluno: aluno.id,
                nomeAluno: aluno.nome,
              ),
        ),
      );
    }
  }
  */
  Future<void> verificarMatriculaAluno(
    BuildContext context,
    Usuario aluno,
  ) async {
    final dao = MatriculaDao();
    final matricula = await dao.getPrimeiraMatriculaPorUsuario(aluno.id);

    if (matricula != null) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => AlunoPainel(
                idAluno: aluno.id,
                idEstudo: matricula.idEstudoBiblico,
                nomeAluno: aluno.nome,
              ),
        ),
      );
    } else {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => MatriculaAlunoScreen(
                idAluno: aluno.id,
                nomeAluno: aluno.nome,
              ),
        ),
      );
    }

    // Recarrega os dados após o retorno
    await _carregarAlunos();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      titulo: 'Meus Alunos',
      isLoading: _isLoading,
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
          if (_alunos.isEmpty && !_isLoading)
            const Center(child: Text('Nenhum aluno encontrado')),
          ..._alunos.asMap().entries.map((entry) {
            final index = entry.key;
            final aluno = entry.value;
            final avatarEmoji = sortearEmoji(aluno.sexo);
            final pontos = _pontosPorAluno[aluno.id] ?? 0;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AlunoItem(
                posicao: index + 1,
                nome: aluno.nome,
                pontos: pontos,
                avatar: avatarEmoji,
                iconCoroa: 'assets/icons/hex_coroa_cinza.svg',
                onTap: () => verificarMatriculaAluno(context, aluno),
              ),
            );
          }),
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
  final VoidCallback onTap;

  const AlunoItem({
    super.key,
    required this.posicao,
    required this.nome,
    required this.pontos,
    required this.avatar,
    this.iconCoroa,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                    '$pontos Licões Concluídas',
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
      ),
    );
  }
}
