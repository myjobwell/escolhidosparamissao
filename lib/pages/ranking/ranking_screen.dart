import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../core/global.dart';
import '../../widgets/background_home.dart';
import '../../widgets/podium_widget.dart';
import '../../widgets/podium_professores_widget.dart';
import '../../services/ranking_service.dart';
import '../../widgets/app_bar.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  String nomeUsuario = '';
  final int pageSize = 10;
  final RankingGeralService _rankingService = RankingGeralService();

  List<Professor> displayedProfessores = [];
  bool _isLoading = false;
  bool _hasMore = true;
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    nomeUsuario = nomeUsuarioGlobal ?? '';
    _verificarConexaoInicial();
  }

  Future<void> _verificarConexaoInicial() async {
    final connectivity = await Connectivity().checkConnectivity();
    setState(() {
      _isOnline = connectivity != ConnectivityResult.none;
    });

    if (_isOnline) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    final nextPage = await _rankingService.getNextRankingPage(
      pageSize: pageSize,
    );

    if (nextPage.isEmpty) {
      setState(() {
        _hasMore = false;
        _isLoading = false;
      });
      return;
    }

    final novosProfessores =
        nextPage
            .map(
              (data) => Professor(
                nome: data['nome'] ?? 'Sem nome',
                distrito: data['igrejaNome'] ?? '---',
                pontos: data['totalPontos'] ?? 0,
                sexo: data['sexo'] ?? 'masculino',
              ),
            )
            .toList();

    final existeDuplicado = novosProfessores.every(
      (novo) => displayedProfessores.any(
        (existente) =>
            existente.nome == novo.nome &&
            existente.distrito == novo.distrito &&
            existente.pontos == novo.pontos,
      ),
    );

    if (existeDuplicado) {
      setState(() {
        _hasMore = false;
        _isLoading = false;
      });
      return;
    }

    setState(() {
      displayedProfessores.addAll(novosProfessores);
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _rankingService.resetPagination();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titulo: 'Ranking',
        exibirSaudacao: true,
        exibirBotaoVoltar: true,
        centralizarTitulo: true,
        onBackTap: () => Navigator.of(context).pop(),
        onSettingsTap: () {},
      ),
      /*
      body: BackgroundHome(
        child: SafeArea(
          child:
              _isOnline
                  ? Column(
                    children: [
                      const SizedBox(height: 0),
                      Center(
                        child: Image.asset(
                          'assets/imgs/l_color_open.png',
                          height: 60,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 75),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Podium(),
                      ),
                      const SizedBox(height: 16),
                      /* Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Transform.translate(
                            offset: const Offset(0, -165),
                            child: PodiumProfessores(
                              professores: displayedProfessores,
                              onLoadMore: _loadMore,
                              isLoading: _isLoading,
                              hasMore: _hasMore,
                            ),
                          ),
                        ),
                      ), */
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: PodiumProfessores(
                            professores: displayedProfessores,
                            onLoadMore: _loadMore,
                            isLoading: _isLoading,
                            hasMore: _hasMore,
                          ),
                        ),
                      ),
                    ],
                  )
                  : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.wifi_off,
                            size: 48,
                            color: Colors.white70,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Você precisa estar conectado à internet para ver o ranking.',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          TextButton.icon(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Voltar',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              backgroundColor: Colors.white24,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
        ),
      ),
      */
      body: BackgroundHome(
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 0),
                  Center(
                    child: Image.asset(
                      'assets/imgs/l_color_open.png',
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 75),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Podium(),
                  ),
                ],
              ),
              Positioned(
                top: 365, // ajuste essa altura como quiser
                left: 16,
                right: 16,
                bottom: 0,
                child: PodiumProfessores(
                  professores: displayedProfessores,
                  onLoadMore: _loadMore,
                  isLoading: _isLoading,
                  hasMore: _hasMore,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
