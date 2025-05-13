import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../widgets/layout_page.dart';
import '../../widgets/aluno_dashboard_widget.dart';
import '../../widgets/licao_item_widget.dart';
import '../../models/licoes_model.dart';
import '../../databases/estudos_dao.dart';
import '../estudos/conteudos_screen.dart';
import '../../databases/licoes_dadas_dao.dart';
import '../../models/licoes_dadas_model.dart';
import '../../services/sincronizacao/firebase_licoes_dadas_service.dart';
import '../../core/global.dart';
import '../../databases/ranking_dao.dart';
import '../../databases/app_database.dart';

class AlunoPainel extends StatefulWidget {
  final String idAluno;
  final int idEstudo;
  final String nomeAluno;

  const AlunoPainel({
    super.key,
    required this.idAluno,
    required this.idEstudo,
    required this.nomeAluno,
  });

  @override
  State<AlunoPainel> createState() => _AlunoPainelState();
}

class _AlunoPainelState extends State<AlunoPainel> {
  String nomeEstudo = '';
  int totalLicoes = 0;
  bool carregandoEstudo = true;
  List<Licao> licoes = [];
  Map<int, int> licoesDadasMap = {};

  @override
  void initState() {
    super.initState();
    _carregarDadosDoEstudo();
  }

  Future<void> _carregarDadosDoEstudo() async {
    final estudo = await DbEstudos.buscarEstudoPorId(widget.idEstudo);
    final licoesCarregadas = await DbEstudos.listarLicoesPorEstudo(
      widget.idEstudo,
    );
    final dao = LicoesDadasDao();
    final status = await dao.buscarStatusLicoesChecadas(
      idUsuario: widget.idAluno,
      idEstudoBiblico: widget.idEstudo,
    );

    setState(() {
      nomeEstudo = estudo?.nome ?? 'Estudo Desconhecido';
      licoes = licoesCarregadas;
      totalLicoes = licoes.length;
      licoesDadasMap = status;
      carregandoEstudo = false;
    });
  }

  String _dataAtualFormatada() {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  }

  Future<void> _alternarConclusao(Licao licao) async {
    if (cpfLogado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro: Professor não identificado.')),
      );
      return;
    }

    final dao = LicoesDadasDao();

    final existente = await dao.buscarPorUsuarioEstudoLicao(
      widget.idAluno,
      widget.idEstudo,
      licao.id,
    );

    final bool novoStatus = !(existente?.checado ?? false);

    final LicoesDadas atualizada =
        existente != null
            ? existente.copyWith(
              checado: novoStatus,
              sincronizado: 0,
              idProfessor: cpfLogado!,
              dataUpdate: _dataAtualFormatada(),
            )
            : LicoesDadas(
              idUsuario: widget.idAluno,
              idEstudoBiblico: widget.idEstudo,
              idLicao: licao.id,
              sincronizado: 0,
              checado: true,
              idProfessor: cpfLogado!,
              dataUpdate: _dataAtualFormatada(),
            );

    if (existente != null) {
      await dao.atualizar(atualizada);
    } else {
      await dao.salvar(atualizada);
    }

    setState(() {
      licoesDadasMap[licao.id] = atualizada.checado ? 1 : 0;
    });

    final db = await AppDatabase.getDatabase();
    final rankingDao = RankingDao(db);
    await rankingDao.atualizarTotalAulas(
      idProfessor: cpfLogado!,
      incrementar: atualizada.checado,
    );

    final connectivity = await Connectivity().checkConnectivity();
    final online = connectivity != ConnectivityResult.none;

    if (online) {
      try {
        await FirebaseLicoesService.sincronizarLicao(atualizada);
        final lAtual = await dao.buscarPorUsuarioEstudoLicao(
          widget.idAluno,
          widget.idEstudo,
          licao.id,
        );

        if (lAtual != null && lAtual.id != null) {
          await dao.atualizar(
            lAtual.copyWith(
              sincronizado: 1,
              idProfessor: cpfLogado!,
              dataUpdate: _dataAtualFormatada(),
            ),
          );
        }
      } catch (e) {
        debugPrint('❌ Erro ao sincronizar lição com Firebase: $e');
      }
    } else {
      print(
        '📴 Offline. Lição salva localmente. Sincronização futura pendente.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      titulo: 'Painel do Aluno',
      isLoading: carregandoEstudo,
      exibirBotaoVoltar: true,
      exibirSaudacao: true,
      centralizarTitulo: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StudyCard(
            title: nomeEstudo,
            completedLessons: licoesDadasMap.values.where((v) => v == 1).length,
            totalLessons: totalLicoes,
            nomeAluno: widget.nomeAluno,
          ),
          const SizedBox(height: 12),
          const Text(
            'Lições',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (carregandoEstudo)
            const Center(child: CircularProgressIndicator())
          else if (licoes.isEmpty)
            const Center(child: Text('Nenhuma lição encontrada.'))
          else
            ...licoes.map((licao) {
              final concluido = licoesDadasMap[licao.id] ?? 0;
              return LicaoItemWidget(
                numero: licoes.indexOf(licao) + 1,
                titulo: licao.nome,
                concluido: concluido,
                onTituloTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => ConteudosPage(
                            idLicao: licao.id,
                            tituloLicao: licao.nome,
                          ),
                    ),
                  );
                },
                onConcluirTap: () async {
                  await _alternarConclusao(licao);
                },
              );
            }).toList(),
        ],
      ),
    );
  }
}


/* import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../widgets/layout_page.dart';
import '../../widgets/aluno_dashboard_widget.dart';
import '../../widgets/licao_item_widget.dart';
import '../../models/licoes_model.dart';
import '../../databases/estudos_dao.dart';
import '../estudos/conteudos_screen.dart';
import '../../databases/licoes_dadas_dao.dart';
import '../../models/licoes_dadas_model.dart';
import '../../services/sincronizacao/firebase_licoes_dadas_service.dart';
import '../../core/global.dart';
import '../../databases/ranking_dao.dart';
import '../../databases/app_database.dart';

class AlunoPainel extends StatefulWidget {
  final String idAluno;
  final int idEstudo;
  final String nomeAluno;

  const AlunoPainel({
    super.key,
    required this.idAluno,
    required this.idEstudo,
    required this.nomeAluno,
  });

  @override
  State<AlunoPainel> createState() => _AlunoPainelState();
}

class _AlunoPainelState extends State<AlunoPainel> {
  String nomeEstudo = '';
  int totalLicoes = 0;
  bool carregandoEstudo = true;
  List<Licao> licoes = [];
  Map<int, int> licoesDadasMap = {};

  @override
  void initState() {
    super.initState();
    _carregarDadosDoEstudo();
  }

  Future<void> _carregarDadosDoEstudo() async {
    final estudo = await DbEstudos.buscarEstudoPorId(widget.idEstudo);
    final licoesCarregadas = await DbEstudos.listarLicoesPorEstudo(
      widget.idEstudo,
    );
    final dao = LicoesDadasDao();
    final status = await dao.buscarStatusLicoesChecadas(
      idUsuario: widget.idAluno,
      idEstudoBiblico: widget.idEstudo,
    );

    setState(() {
      nomeEstudo = estudo?.nome ?? 'Estudo Desconhecido';
      licoes = licoesCarregadas;
      totalLicoes = licoes.length;
      licoesDadasMap = status;
      carregandoEstudo = false;
    });
  }

  String _dataAtualFormatada() {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  }

  Future<void> _alternarConclusao(Licao licao) async {
    final dao = LicoesDadasDao();

    final existente = await dao.buscarPorUsuarioEstudoLicao(
      widget.idAluno,
      widget.idEstudo,
      licao.id,
    );

    final bool novoStatus = !(existente?.checado ?? false);

    final LicoesDadas atualizada =
        existente != null
            ? existente.copyWith(
              checado: novoStatus,
              sincronizado: 0,
              idProfessor: cpfLogado,
              dataUpdate: _dataAtualFormatada(),
            )
            : LicoesDadas(
              idUsuario: widget.idAluno,
              idEstudoBiblico: widget.idEstudo,
              idLicao: licao.id,
              sincronizado: 0,
              checado: true,
              idProfessor: cpfLogado,
              dataUpdate: _dataAtualFormatada(),
            );

    if (existente != null) {
      await dao.atualizar(atualizada);
    } else {
      await dao.salvar(atualizada);
    }

    // ✅ Atualiza a UI imediatamente
    setState(() {
      licoesDadasMap[licao.id] = atualizada.checado ? 1 : 0;
    });

    // ✅ Atualiza ranking local
    final db = await AppDatabase.getDatabase();
    final rankingDao = RankingDao(db);
    await rankingDao.atualizarTotalAulas(
      idProfessor: cpfLogado!,
      incrementar: atualizada.checado,
    );

    // 🔄 Tenta sincronizar em segundo plano
    final connectivity = await Connectivity().checkConnectivity();
    final online = connectivity != ConnectivityResult.none;

    if (online) {
      try {
        await FirebaseLicoesService.sincronizarLicao(atualizada);
        final lAtual = await dao.buscarPorUsuarioEstudoLicao(
          widget.idAluno,
          widget.idEstudo,
          licao.id,
        );

        if (lAtual != null && lAtual.id != null) {
          await dao.atualizar(
            lAtual.copyWith(
              sincronizado: 1,
              idProfessor: cpfLogado,
              dataUpdate: _dataAtualFormatada(),
            ),
          );
        }
      } catch (e) {
        debugPrint('❌ Erro ao sincronizar lição com Firebase: $e');
      }
    } else {
      print(
        '📴 Offline. Lição salva localmente. Sincronização futura pendente.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      titulo: 'Painel do Aluno',
      isLoading: carregandoEstudo,
      exibirBotaoVoltar: true,
      exibirSaudacao: true,
      centralizarTitulo: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StudyCard(
            title: nomeEstudo,
            completedLessons: licoesDadasMap.values.where((v) => v == 1).length,
            totalLessons: totalLicoes,
            nomeAluno: widget.nomeAluno,
          ),
          const SizedBox(height: 12),
          const Text(
            'Lições',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (carregandoEstudo)
            const Center(child: CircularProgressIndicator())
          else if (licoes.isEmpty)
            const Center(child: Text('Nenhuma lição encontrada.'))
          else
            ...licoes.map((licao) {
              final concluido = licoesDadasMap[licao.id] ?? 0;
              return LicaoItemWidget(
                numero: licoes.indexOf(licao) + 1,
                titulo: licao.nome,
                concluido: concluido,
                onTituloTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => ConteudosPage(
                            idLicao: licao.id,
                            tituloLicao: licao.nome,
                          ),
                    ),
                  );
                },
                onConcluirTap: () async {
                  await _alternarConclusao(licao);
                },
              );
            }).toList(),
        ],
      ),
    );
  }
}
 */