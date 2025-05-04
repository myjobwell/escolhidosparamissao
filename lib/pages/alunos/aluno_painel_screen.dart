import 'package:flutter/material.dart';
import '../../widgets/layout_page.dart';
import '../../widgets/aluno_dashboard_widget.dart';
import '../../widgets/licao_item_widget.dart';
import '../../models/licoes_model.dart';
import '../../models/estudos_biblicos_model.dart';
import '../../databases/estudos_dao.dart';
import '../estudos/conteudos_screen.dart';
import '../../databases/licoes_dadas_dao.dart';
import '../../models/licoes_dadas_model.dart';

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
  int completedLessons = 0;
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

  Future<bool> _alternarConclusao(Licao licao) async {
    final dao = LicoesDadasDao();

    final existente = await dao.buscarPorUsuarioEstudoLicao(
      widget.idAluno,
      widget.idEstudo,
      licao.id,
    );

    if (existente != null) {
      final atualizado = existente.copyWith(checado: !existente.checado);
      await dao.atualizar(atualizado);

      setState(() {
        licoesDadasMap[licao.id] = atualizado.checado ? 1 : 0;
      });

      return atualizado.checado;
    } else {
      final nova = LicoesDadas(
        idUsuario: widget.idAluno,
        idEstudoBiblico: widget.idEstudo,
        idLicao: licao.id,
        sincronizado: 0,
        checado: true,
      );
      await dao.salvar(nova);

      setState(() {
        licoesDadasMap[licao.id] = 1;
      });

      return true;
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
                onConcluirTap: () => _alternarConclusao(licao),
              );
            }).toList(),
        ],
      ),
    );
  }
}
