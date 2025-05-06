import 'package:flutter/material.dart';
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
