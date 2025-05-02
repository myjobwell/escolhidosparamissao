import 'package:flutter/material.dart';
import '../../widgets/layout_page.dart';
import '../../widgets/bloco_item_widget.dart';
import '../../models/estudos_biblicos_model.dart';
import '../../databases/estudos_dao.dart';

class MatriculaAlunoScreen extends StatefulWidget {
  final String idAluno;

  const MatriculaAlunoScreen({super.key, required this.idAluno});

  @override
  State<MatriculaAlunoScreen> createState() => _MatriculaAlunoScreenState();
}

class _MatriculaAlunoScreenState extends State<MatriculaAlunoScreen> {
  List<EstudoBiblico> estudos = [];
  Map<int, int> totalLicoesPorEstudo = {};
  bool isLoading = true;
  int? _indiceSelecionado;

  @override
  void initState() {
    super.initState();
    carregarEstudosComLicoes();
  }

  Future<void> carregarEstudosComLicoes() async {
    final dados = await DbEstudos.listarEstudos();
    final Map<int, int> mapaLicoes = {};

    for (final estudo in dados) {
      final licoes = await DbEstudos.listarLicoesPorEstudo(estudo.id);
      mapaLicoes[estudo.id] = licoes.length;
    }

    setState(() {
      estudos = dados;
      totalLicoesPorEstudo = mapaLicoes;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      titulo: 'Matricular Aluno',
      isLoading: isLoading,
      exibirBotaoVoltar: true,
      exibirSaudacao: true,
      centralizarTitulo: true,
      child:
          estudos.isEmpty
              ? const Center(child: Text('Nenhum estudo encontrado.'))
              : Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 12),
                  itemCount: estudos.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.9,
                  ),
                  itemBuilder: (context, index) {
                    final estudo = estudos[index];
                    final selecionado = _indiceSelecionado == index;
                    final totalLicoes = totalLicoesPorEstudo[estudo.id] ?? 0;

                    return BlocoItemWidget(
                      item: BlocoItem(
                        estudo.nome,
                        '$totalLicoes lições',
                        Icons.menu_book,
                      ),
                      selecionado: selecionado,
                      index: index,
                      onTap: () {
                        setState(() {
                          _indiceSelecionado = index;
                        });

                        // aqui você pode registrar a matrícula com estudo.id e widget.idAluno
                      },
                    );
                  },
                ),
              ),
    );
  }
}
