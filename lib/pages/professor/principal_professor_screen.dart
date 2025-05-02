import 'package:flutter/material.dart';
import '../../core/global.dart';
import '../../widgets/card_widget.dart';
import '../../widgets/lista_de_alunos.dart';
import '../../databases/usuario_dao.dart';
import '../estudos/estudos_biblicos_screen.dart';
import '../../widgets/FadeInWrapper.dart';
import '../../widgets/layout_page.dart';
import '../../widgets/app_bar.dart'; // BasePage personalizado
import '../alunos/aluno_screen.dart';

class PageProfessor extends StatefulWidget {
  const PageProfessor({super.key});

  @override
  State<PageProfessor> createState() => _PageProfessorState();
}

class _PageProfessorState extends State<PageProfessor> {
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
    return BasePage(
      titulo: 'Evangelize',
      isLoading: isLoading,
      centralizarTitulo: true,
      tamanhoTitulo: 24.0,
      exibirBotaoVoltar: false,
      exibirSaudacao: true,
      child: FadeInWrapper(
        child: Column(
          children: [
            CardWidget(
              icon: Icons.bar_chart,
              iconColor: Colors.black,
              backgroundColor: const Color(0xFFE6F0FA),
              title: 'Meus Alunos',
              subtitle: 'Gerencie quem recebe estudo',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AlunosPage()),
                );
              },
            ),
            const SizedBox(height: 10),
            CardWidget(
              icon: Icons.bar_chart,
              iconColor: Colors.black,
              backgroundColor: const Color(0xFFE6F0FA),
              title: 'Ranking de Professores',
              subtitle: 'Professores mais ativos',
              onTap: () {},
            ),
            const SizedBox(height: 10),
            CardWidget(
              icon: Icons.insights,
              iconColor: Colors.red,
              backgroundColor: const Color(0xFFFDEEEF),
              title: 'Meu Desempenho',
              subtitle: 'Meus resultados',
              onTap: () {},
            ),
            const SizedBox(height: 10),
            CardWidget(
              icon: Icons.insights,
              iconColor: Colors.white,
              backgroundColor: const Color.fromARGB(255, 45, 216, 22),
              title: 'Estudos Bíblicos',
              subtitle: 'Conteúdos disponíveis',
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
    );
  }
}
