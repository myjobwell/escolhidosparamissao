import 'package:flutter/material.dart';
import '../../core/global.dart';
import '../../widgets/background_home.dart';
import '../../widgets/podium_widget.dart';
import '../../widgets/podium_professores_widget.dart';
import '../../services/ranking_service.dart'; // Arquivo unificado com RankingGeralService

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  String nomeUsuario = '';
  final int pageSize = 10;
  final ScrollController _scrollController = ScrollController();
  final RankingGeralService _rankingService = RankingGeralService();

  List<Professor> displayedProfessores = [];
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    nomeUsuario = nomeUsuarioGlobal ?? '';
    _loadMore();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoading &&
          _hasMore) {
        _loadMore();
      }
    });
  }

  Future<void> _loadMore() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    final nextPage = await _rankingService.getNextRankingPage(
      pageSize: pageSize,
    );

    if (nextPage.isEmpty) {
      _hasMore = false;
    } else {
      setState(() {
        displayedProfessores.addAll(
          nextPage.map(
            (data) => Professor(
              nome: data['nome'] ?? 'Sem nome',
              distrito: data['igrejaNome'] ?? '---', // <- substituição aqui
              pontos: data['totalPontos'] ?? 0,
              sexo: data['sexo'] ?? 'masculino',
            ),
          ),
        );
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _rankingService.resetPagination();
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
              if (displayedProfessores.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Transform.translate(
                    offset: const Offset(0, -140),
                    child: PodiumProfessores(professores: displayedProfessores),
                  ),
                ),
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
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
