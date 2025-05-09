import 'package:flutter/material.dart';
import '../../core/global.dart';
import '../../widgets/background_home.dart';
import '../../widgets/podium_widget.dart'; // Top 3
import '../../widgets/podium_professores_widget.dart'; // Resto do ranking

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  String nomeUsuario = '';

  final List<String> nomes = ['Adison Press', 'Ruben Geidt', 'Jakob Levin'];
  final List<int> pontos = [2569, 1469, 1053];
  final List<String> sexos = ['feminino', 'masculino', 'masculino'];
  final List<String> distritos = ['Zona Sul', 'Zona Norte', 'Zona Leste'];

  final List<Professor> professoresRestantes = List.generate(
    21,
    (i) => Professor(
      nome: 'Professor ${i + 4}',
      distrito: 'Distrito ${i + 4}',
      pontos: 400 + (i % 5) * 10,
      sexo: i % 2 == 0 ? 'masculino' : 'feminino',
    ),
  );

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
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildCustomAppBar(context),
              const SizedBox(height: 8),
              Center(
                child: Image.asset(
                  'assets/imgs/l_color_open.png',
                  height: 50,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 40),

              // 🔽 Stack que exibe Podium (fundo) e PodiumProfessores (sobreposto)
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  // Podium no fundo
                  Podium(
                    nomes: nomes,
                    pontos: pontos,
                    sexos: sexos,
                    distritos: distritos,
                  ),

                  // Ranking sobreposto
                  Padding(
                    padding: const EdgeInsets.only(top: 230),
                    child: PodiumProfessores(professores: professoresRestantes),
                  ),
                ],
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
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
              // ação de configurações
            },
          ),
        ],
      ),
    );
  }
}



/* import 'package:flutter/material.dart';
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
  final List<String> distritos = ['Zona Sul', 'Zona Norte', 'Zona Leste'];

  @override
  void initState() {
    super.initState();
    nomeUsuario = nomeUsuarioGlobal ?? '';
  }

  /*
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
              Podium(
                nomes: nomes,
                pontos: pontos,
                sexos: sexos,
                distritos: distritos,
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
  */
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
                  height: 50,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(
                height: 75,
              ), // 🔽 Espaço antes do pódio (ajuste aqui se quiser mais ou menos)
              Podium(
                nomes: nomes,
                pontos: pontos,
                sexos: sexos,
                distritos: distritos,
              ),
              const SizedBox(
                height: 20,
              ), // 🔽 Espaço abaixo do pódio (reduzido para trazer ele para cima)
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