import 'package:flutter/material.dart';
import '../../core/global.dart';
import '../../databases/app_database.dart';
import '../../components/card_widget.dart'; // ✅ Import do novo CardWidget
import '../../components/title_widget.dart'; // ✅ Import do novo TitleWidget

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
                            onTap: () {
                              // Ação futura
                            },
                          ),
                          const SizedBox(height: 10),
                          CardWidget(
                            icon: Icons.insights,
                            iconColor: Colors.red,
                            backgroundColor: const Color(0xFFFDEEEF),
                            title: 'Meu Desempenho',
                            subtitle: 'Meus resultados',
                            onTap: () {
                              // Ação futura
                            },
                          ),
                          TextButton(
                            onPressed: () {
                              // Temporariamente inativo
                            },
                            child: const Text(
                              '+Adicionar Professor',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0B1121),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Alunos',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0B1121),
                            ),
                          ),
                          const SizedBox(height: 15),
                          TitleWidget(
                            name: 'Lucas Silva',
                            progress: '15 Estudos Bíblicos',
                            bgColor: Colors.blue[100]!,
                          ),
                          TitleWidget(
                            name: 'Mariana Costa',
                            progress: '12 Estudos Bíblicos',
                            bgColor: Colors.green[100]!,
                          ),
                          TitleWidget(
                            name: 'Carlos Pereira',
                            progress: '20 Estudos Bíblicos',
                            bgColor: Colors.purple[100]!,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
