import 'package:flutter/material.dart';
import '../../core/global.dart';
import '../../components/card_widget.dart';
import '../../components/lista_de_alunos.dart';
import '../../databases/db_usuario.dart';
import '../estudos/estudos_biblicos.dart';
import '../../components/app_bar.dart';
import '../../components/FadeInWrapper.dart'; // ✅ Import do FadeInWrapper

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
          nomeUsuarioGlobal =
              usuario.nome ?? ''; // Garantia de global atualizado
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1121),
      //appbar
      appBar: CustomAppBar(
        titulo: 'Perfil',
        exibirSaudacao: true,
        exibirBotaoVoltar: false,
      ),

      //fim appbar
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
              : Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      child: FadeInWrapper(
                        child: ListView(
                          children: [
                            const SizedBox(height: 15),
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
                              iconColor: Colors.red,
                              backgroundColor: const Color.fromARGB(
                                255,
                                45,
                                216,
                                22,
                              ),
                              title: 'Estudos Bíblicos',
                              subtitle: 'Conteúdos disponíveis',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EstudosBiblicosPage(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0B1121),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 14,
                                ),
                              ),
                              icon: const Icon(
                                Icons.person_add,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Adicionar Aluno',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                // Futuro: abrir cadastro de aluno
                              },
                            ),
                            const SizedBox(height: 20),
                            const ListaDeAlunos(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
