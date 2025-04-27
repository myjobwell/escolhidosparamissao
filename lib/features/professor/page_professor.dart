import 'package:flutter/material.dart';
import '../../core/global.dart'; // Variável global do CPF logado
import '../../databases/app_database.dart'; // Banco de dados local

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

    // ✅ Inicializa a animação logo no início
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

        _controller
            .forward(); // ✅ Dispara a animação depois que carregar o nome
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Meus Professores',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
              : Column(
                children: [
                  const SizedBox(height: 20),
                  if (nomeUsuario.isNotEmpty)
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Bem-vindo! ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              TextSpan(
                                text: nomeUsuario,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C2333),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          icon: Icon(Icons.search, color: Colors.white54),
                          hintText: 'Pesquisar professor',
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
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
                          const SizedBox(height: 15),
                          _cardTile(
                            icon: Icons.bar_chart,
                            iconColor: Colors.black,
                            background: const Color(0xFFE6F0FA),
                            title: 'Ranking de Professores',
                            subtitle: 'Professores mais ativos',
                            onTap: () {
                              // Temporariamente inativo
                            },
                          ),
                          const SizedBox(height: 10),
                          _cardTile(
                            icon: Icons.insights,
                            iconColor: Colors.red,
                            background: const Color(0xFFFDEEEF),
                            title: 'Meu Desempenho',
                            subtitle: 'Meus resultados',
                            onTap: () {
                              // Temporariamente inativo
                            },
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Professores',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0B1121),
                            ),
                          ),
                          const SizedBox(height: 15),
                          _professorTile(
                            context,
                            'Lucas Silva',
                            '15 Estudos Bíblicos',
                            Colors.blue[100]!,
                          ),
                          _professorTile(
                            context,
                            'Mariana Costa',
                            '12 Estudos Bíblicos',
                            Colors.green[100]!,
                          ),
                          _professorTile(
                            context,
                            'Carlos Pereira',
                            '20 Estudos Bíblicos',
                            Colors.purple[100]!,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _cardTile({
    required IconData icon,
    required Color iconColor,
    required Color background,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 24,
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0B1121),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black),
          ],
        ),
      ),
    );
  }

  Widget _professorTile(
    BuildContext context,
    String name,
    String progress,
    Color bgColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: bgColor,
            radius: 24,
            child: const Icon(Icons.person, color: Colors.black),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B1121),
                ),
              ),
              Text(
                progress,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
