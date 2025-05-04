import 'package:flutter/material.dart';
import '../../widgets/layout_page.dart';
import '../../widgets/aluno_dashboard_widget.dart';
import '../../widgets/licao_item_widget.dart';
import '../../models/licoes_model.dart';
import '../../models/estudos_biblicos_model.dart';
import '../../databases/estudos_dao.dart';
import '../estudos/conteudos_screen.dart';
import '../../databases/licoes_dadas_dao.dart';
import '../../models/licoes_dadas_model.dart'; // ❗ Adicione essa linha

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
  int? idLicaoSelecionada;

  @override
  void initState() {
    super.initState();
    _carregarDadosDoEstudo();
  }

  // ✅ Novo método para buscar o nome do estudo e o total de lições com base no idEstudo
  Future<void> _carregarDadosDoEstudo() async {
    final estudo = await DbEstudos.buscarEstudoPorId(widget.idEstudo);
    final licoes = await DbEstudos.listarLicoesPorEstudo(widget.idEstudo);

    setState(() {
      nomeEstudo = estudo?.nome ?? 'Estudo Desconhecido';
      totalLicoes = licoes.length; // ✅ Aqui armazenamos a contagem das lições
      carregandoEstudo = false;
    });
  }

  Future<Map<int, int>> carregarLicoesDadas() async {
    final dao = LicoesDadasDao();
    return await dao.buscarStatusLicoesChecadas(
      idUsuario: widget.idAluno,
      idEstudoBiblico: widget.idEstudo,
    );
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
            completedLessons: completedLessons,
            totalLessons: totalLicoes,
            nomeAluno: widget.nomeAluno,
          ),
          const SizedBox(height: 12),
          const Text(
            'Lições',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          FutureBuilder<List<Licao>>(
            future: DbEstudos.listarLicoesPorEstudo(widget.idEstudo),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data!.isEmpty) {
                return const Center(child: Text('Nenhuma lição encontrada.'));
              }

              final licoes = snapshot.data!;

              return FutureBuilder<Map<int, int>>(
                future: carregarLicoesDadas(), // ← carrega os dados com checado
                builder: (context, dadoSnapshot) {
                  if (!dadoSnapshot.hasData) {
                    return const SizedBox();
                  }

                  final licoesDadasMap = dadoSnapshot.data!;

                  return Column(
                    children: List.generate(licoes.length, (index) {
                      final licao = licoes[index];
                      final concluido = licoesDadasMap[licao.id] ?? 0;

                      return LicaoItemWidget(
                        numero: index + 1,
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
                        /*
                        onConcluirTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Item da lição ${licao.nome} apertado',
                              ),
                            ),
                          );
                        },
                        */
                        onConcluirTap: () async {
                          final dao =
                              LicoesDadasDao(); // certifique-se de importar corretamente

                          // Busca se já existe registro
                          final existente = await dao
                              .buscarPorUsuarioEstudoLicao(
                                widget.idAluno,
                                widget.idEstudo,
                                licao.id,
                              );

                          if (existente != null) {
                            // Alterna checado: se 1 vira 0, se 0 vira 1
                            final atualizado = existente.copyWith(
                              checado: !existente.checado,
                            );
                            await dao.atualizar(atualizado);
                          } else {
                            // Cria novo com checado = true
                            final nova = LicoesDadas(
                              idUsuario: widget.idAluno,
                              idEstudoBiblico: widget.idEstudo,
                              idLicao: licao.id,
                              sincronizado: 0,
                              checado: true,
                            );
                            await dao.salvar(nova);
                          }

                          // Atualiza a interface
                          setState(() {});
                        },
                      );
                    }),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
