import 'package:flutter/material.dart';
import '../../core/global.dart';
import '../../databases/app_database.dart';
import '../../components/card_widget.dart';
import '../../components/title_widget.dart';
import '../../components/lista_de_alunos.dart'; // ✅ Import do widget de lista de alunos

class PageProfessor extends StatefulWidget {
  const PageProfessor({super.key});

  @override
  State<PageProfessor> createState() => _PageProfessorState();
}

class _PageProfessorState extends State<PageProfessor>
    with SingleTickerProviderStateMixin {
  String nomeUsuario = '';
  bool isLoading = true;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _carregarDadosUsuario();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _carregarDadosUsuario() async {
    if (cpfLogado != null) {
      final usuario = await DbUsuario.buscarUsuarioPorCpf(cpfLogado!);

      if (usuario != null) {
        setState(() {
          nomeUsuario = usuario.nome ?? '';
          isLoading = false;
        });
        _controller.forward();
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1121),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Bem-vindo! ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: nomeUsuario,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                // Futuro: abrir página de configurações
              },
            ),
          ],
        ),
      ),
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
                          const ListaDeAlunos(), // ✅ Aqui chamando o widget separado
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
