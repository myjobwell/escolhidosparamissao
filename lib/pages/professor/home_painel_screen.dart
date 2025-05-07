import 'package:flutter/material.dart';
import '../../core/global.dart';
import '../../databases/usuario_dao.dart';
import '../../widgets/FadeInWrapper.dart';
import '../../widgets/layout_home.dart';
import '../../widgets/resumo_painel_professor_widget.dart';
import '../../widgets/card_widget.dart';
import '../alunos/aluno_screen.dart';
import '../estudos/estudos_biblicos_screen.dart'; // Certifique-se de que está atualizado

class HomePainel extends StatefulWidget {
  const HomePainel({super.key});

  @override
  State<HomePainel> createState() => _HomePainelState();
}

class _HomePainelState extends State<HomePainel> {
  String nomeUsuario = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarDadosUsuario();
  }

  Future<void> _carregarDadosUsuario() async {
    if (cpfLogado != null) {
      final usuario = await DbUsuario.buscarUsuarioPorCpf(cpfLogado!);
      if (usuario != null) {
        setState(() {
          nomeUsuario = usuario.nome ?? '';
          nomeUsuarioGlobal = usuario.nome ?? '';
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ResumoPainelProfessor(
                totalEstudos: 10,
                totalAulas: 151,
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
                      );
                    },
                  ),
                  CardWidget(
                    backgroundColor: const Color(0xFF0B1121),
                    image: const AssetImage('assets/imgs/logo_meu_ranking.png'),
                    imageWidth: 110,
                    imageHeight: 80,
                    onTap: () {
                      print('Card clicado');
                    },
                  ),
                  CardWidget(
                    backgroundColor: const Color(0xFF0B1121),
                    image: const AssetImage(
                      'assets/imgs/logo_meus_estudos.png',
                    ),
                    imageWidth: 100,
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





/* import 'package:flutter/material.dart';
import '../../core/global.dart';
import '../../databases/usuario_dao.dart';
import '../../widgets/FadeInWrapper.dart';
import '../../widgets/layout_home.dart';
import '../../widgets/resumo_painel_professor_widget.dart';

class HomePainel extends StatefulWidget {
  const HomePainel({super.key});

  @override
  State<HomePainel> createState() => _HomePainelState();
}

class _HomePainelState extends State<HomePainel> {
  String nomeUsuario = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarDadosUsuario();
  }

  Future<void> _carregarDadosUsuario() async {
    if (cpfLogado != null) {
      final usuario = await DbUsuario.buscarUsuarioPorCpf(cpfLogado!);
      if (usuario != null) {
        setState(() {
          nomeUsuario = usuario.nome ?? '';
          nomeUsuarioGlobal = usuario.nome ?? '';
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
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
      child: const FadeInWrapper(
        child: Column(
          children: [
            ResumoPainelProfessor(
              totalEstudos: 10,
              totalAulas: 151,
              ranking: 56,
            ),
          ],
        ),
      ),
    );
  }
}
 */