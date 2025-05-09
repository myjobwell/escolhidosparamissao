import 'package:flutter/material.dart';
import '../../core/global.dart';
import '../../widgets/background_home.dart';
import '../../widgets/podium_widget.dart';
import '../../widgets/podium_professores_widget.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  String nomeUsuario = '';

  final int pageSize = 7;
  final ScrollController _scrollController = ScrollController();
  List<Professor> allProfessores = [];
  List<Professor> displayedProfessores = [];

  @override
  void initState() {
    super.initState();
    nomeUsuario = nomeUsuarioGlobal ?? '';
    allProfessores = List.generate(
      500,
      (i) => Professor(
        nome: 'Professor ${i + 4}',
        distrito: 'Distrito ${i + 4}',
        pontos: 400 + (i % 5) * 10,
        sexo: i % 2 == 0 ? 'masculino' : 'feminino',
      ),
    );
    _loadMore();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _loadMore();
      }
    });
  }

  void _loadMore() {
    if (displayedProfessores.length >= 50) return;

    final nextPage =
        allProfessores
            .skip(displayedProfessores.length)
            .take(pageSize)
            .toList();

    if (nextPage.isNotEmpty) {
      setState(() {
        displayedProfessores.addAll(nextPage);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundHome(
        child: SafeArea(
          child: ListView(
            controller: _scrollController,
            padding: const EdgeInsets.only(bottom: 32),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildCustomAppBar(context),
              ),
              const SizedBox(height: 8),
              Center(
                child: Image.asset(
                  'assets/imgs/l_color_open.png',
                  height: 50,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 75),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Podium(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Transform.translate(
                  offset: const Offset(0, -140),
                  child: PodiumProfessores(professores: displayedProfessores),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {
    return Row(
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
          onPressed: () {},
        ),
      ],
    );
  }
}
