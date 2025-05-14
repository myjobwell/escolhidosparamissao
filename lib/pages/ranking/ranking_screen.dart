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
      extendBodyBehindAppBar: true,

      appBar: CustomAppBar(
        titulo: 'Ranking',
        exibirSaudacao: true,
        exibirBotaoVoltar: true,
        centralizarTitulo: true,
        onBackTap: () => Navigator.of(context).pop(),
        onSettingsTap: () {},
      ),

      body: Stack(
        children: [
          /// Fundo + conteúdo principal (Podium)
          BackgroundHome(
            child: Column(
              children: const [
                SizedBox(
                  height: 165,
                ), // 👈 Ajusta distância da imagem para o Podium
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Podium(), // 👈 Aqui está o pódio principal
                ),
              ],
            ),
          ),

          /// Imagem sobre AppBar
          Positioned(
            top: 65, // 👈 A posição da imagem no topo da tela
            left: 200,
            right: 0,
            child: Image.asset(
              'assets/imgs/l_color_open.png',
              height: 50, // 👈 Altura da imagem
              fit: BoxFit.contain,
            ),
          ),

          /// Lista dos professores (ranking geral)
          Positioned(
            top: 240, // 👈 Distância do topo até o início da lista
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
    );
  }
}



/* import 'package:flutter/material.dart';
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
      extendBodyBehindAppBar: true, // ✅ permite que o corpo invada o AppBar

      appBar: CustomAppBar(
        titulo: 'Ranking',
        exibirSaudacao: true,
        exibirBotaoVoltar: true,
        centralizarTitulo: true,
        onBackTap: () => Navigator.of(context).pop(),
        onSettingsTap: () {},
      ),

      body: Stack(
        children: [
          /// Fundo com conteúdo principal
          BackgroundHome(
            child: Column(
              children: const [
                SizedBox(height: 120), // espaço após imagem
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Podium(),
                ),
              ],
            ),
          ),

          /// Imagem posicionada sobre o AppBar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/imgs/l_color_open.png',
              height: 80,
              fit: BoxFit.contain,
            ),
          ),

          /// Lista de professores (pódio geral)
          Positioned(
            top: 300, // ajuste conforme layout
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
    );
  }
} */


/* import 'package:flutter/material.dart';
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
      extendBodyBehindAppBar: true,

      appBar: CustomAppBar(
        titulo: 'Ranking',
        exibirSaudacao: true,
        exibirBotaoVoltar: true,
        centralizarTitulo: true,
        onBackTap: () => Navigator.of(context).pop(),
        onSettingsTap: () {},
      ),
      body: BackgroundHome(
        child: SafeArea(
          child: Stack(
            children: [
              /// Corpo principal (exceto imagem e lista)
              Column(
                children: const [
                  SizedBox(height: 80), // Espaço para imagem
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Podium(),
                  ),
                ],
              ),

              /// 🔼 Imagem sobre o AppBar
              Positioned(
                top: -50,
                left: 0,
                right: 0,
                child: Image.asset(
                  'assets/imgs/l_color_open.png',
                  height: 60,
                  fit: BoxFit.contain,
                ),
              ),

              /// 📋 Lista de professores
              Positioned(
                top: 280, // Ajuste conforme necessário
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
} */


/* import 'package:flutter/material.dart';
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
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Podium(),
                  ),
                ],
              ),
              Positioned(
                top: 305, // ajuste essa altura como quiser
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
 */