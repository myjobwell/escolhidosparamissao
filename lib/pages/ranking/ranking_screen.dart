import 'package:flutter/material.dart';
import '../../core/global.dart';
import '../../widgets/background_home.dart';
import '../../widgets/podium_widget.dart'; // assegure-se de que o caminho está correto

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  String nomeUsuario = '';

  // Dados de exemplo para o podium
  final List<String> nomes = ['Adison Press', 'Ruben Geidt', 'Jakob Levin'];
  final List<int> pontos = [2569, 1469, 1053];
  final List<String> sexos = ['feminino', 'masculino', 'masculino'];

  @override
  void initState() {
    super.initState();
    nomeUsuario = nomeUsuarioGlobal ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundHome(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCustomAppBar(context),
              const SizedBox(height: 0),
              Center(
                child: Image.asset(
                  'assets/imgs/l_color_open.png',
                  height: 90,
                  fit: BoxFit.contain,
                ),
              ),
              const Spacer(),
              Podium(nomes: nomes, pontos: pontos, sexos: sexos),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bem-vindo,',
                  style: TextStyle(fontSize: 14, color: Colors.white54),
                ),
                Text(
                  nomeUsuario,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Ação para configurações (opcional)
            },
          ),
        ],
      ),
    );
  }
}



/* import 'package:flutter/material.dart';
import '../../core/global.dart';
import '../../widgets/background_home.dart'; // importa o background customizado

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  String nomeUsuario = '';

  @override
  void initState() {
    super.initState();
    nomeUsuario = nomeUsuarioGlobal ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundHome(
        // ⬅️ aplica o background com círculos
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCustomAppBar(context),
              const SizedBox(height: 0),
              Center(
                child: Image.asset(
                  'assets/imgs/l_color_open.png', // imagem abaixo do appbar
                  height: 90,
                  fit: BoxFit.contain,
                ),
              ),
              const Spacer(),
              const Center(
                child: Text(
                  'Ranking disponível em breve...',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bem-vindo,',
                  style: TextStyle(fontSize: 14, color: Colors.white54),
                ),
                Text(
                  nomeUsuario,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Ação para configurações (opcional)
            },
          ),
        ],
      ),
    );
  }
}
 */