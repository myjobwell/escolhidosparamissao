import 'package:flutter/material.dart';
import '../../widgets/layout_page.dart';
import '../../widgets/aluno_dashboard_widget.dart';
import '../../widgets/licao_item_widget.dart';
import '../../models/licoes_model.dart';
import '../../models/estudos_biblicos_model.dart';
import '../../databases/estudos_dao.dart';
import '../estudos/conteudos_screen.dart';

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
            completedLessons: 8,
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

              return Column(
                children: List.generate(licoes.length, (index) {
                  final licao = licoes[index];
                  return GestureDetector(
                    onTap: () {
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
                    child: LicaoItemWidget(
                      numero: index + 1,
                      titulo: licao.nome,
                      concluida: false,
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}
