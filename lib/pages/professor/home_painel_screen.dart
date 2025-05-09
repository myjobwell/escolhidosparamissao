import 'package:flutter/material.dart';
import '../../core/global.dart';
import '../../databases/usuario_dao.dart';
import '../../databases/licoes_dadas_dao.dart';
import '../../widgets/FadeInWrapper.dart';
import '../../widgets/layout_home.dart';
import '../../widgets/resumo_painel_professor_widget.dart';
import '../../widgets/card_widget.dart';
import '../alunos/aluno_screen.dart';
import '../estudos/estudos_biblicos_screen.dart';
import '../ranking/ranking_screen.dart';

class HomePainel extends StatefulWidget {
  const HomePainel({super.key});

  @override
  State<HomePainel> createState() => _HomePainelState();
}

class _HomePainelState extends State<HomePainel> {
  String nomeUsuario = '';
  int totalEstudos = 0;
  int totalPontos = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarDadosUsuario();
  }

  Future<void> _carregarDadosUsuario() async {
    if (cpfLogado != null) {
      print('CPF Logado: $cpfLogado');
      final usuario = await DbUsuario.buscarUsuarioPorCpf(cpfLogado!);
      final totalUsuarios = await DbUsuario.contarUsuariosPorProfessor(
        cpfLogado!,
      );
      final totalChecadas =
          await LicoesDadasDao.contarLicoesChecadasPorProfessor(cpfLogado!);

      print('Total usuários vinculados: $totalUsuarios');
      print('Total lições checadas: $totalChecadas');

      final pontos = totalUsuarios + totalChecadas;

      if (usuario != null) {
        setState(() {
          nomeUsuario = usuario.nome;
          nomeUsuarioGlobal = usuario.nome;
          totalEstudos = totalUsuarios;
          totalPontos = pontos;
          isLoading = false;
        });
      } else {
        setState(() {
          totalEstudos = totalUsuarios;
          totalPontos = pontos;
          isLoading = false;
        });
      }
    } else {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePageHome(
      titulo: 'Painel Inicial',
      isLoading: isLoading,
      nomeUsuario: nomeUsuario,
      child: FadeInWrapper(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ResumoPainelProfessor(
                totalEstudos: totalEstudos,
                totalPontos: totalPontos,
                ranking: 56,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  CardWidget(
                    backgroundColor: const Color(0xFF0B1121),
                    image: const AssetImage('assets/imgs/logo_meus_alunos.png'),
                    imageWidth: 90,
                    imageHeight: 60,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AlunosPage()),
                      ).then((_) {
                        _carregarDadosUsuario(); // Recarrega ao voltar
                      });
                    },
                  ),
                  CardWidget(
                    backgroundColor: const Color(0xFF0B1121),
                    image: const AssetImage('assets/imgs/logo_meu_ranking.png'),
                    imageWidth: 110,
                    imageHeight: 80,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RankingPage()),
                      ).then((_) {
                        _carregarDadosUsuario(); // Recarrega ao voltar
                      });
                    },
                  ),
                  CardWidget(
                    backgroundColor: const Color(0xFF0B1121),
                    image: const AssetImage(
                      'assets/imgs/logo_estudos_biblicos.png',
                    ),
                    imageWidth: 110,
                    imageHeight: 80,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EstudosBiblicosPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
