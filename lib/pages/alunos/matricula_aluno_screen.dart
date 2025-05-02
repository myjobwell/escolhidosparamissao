import 'package:flutter/material.dart';
import '../../widgets/layout_page.dart';
import '../../widgets/bloco_item_widget.dart';
import '../../widgets/title_widget.dart';
import '../../widgets/button.dart';
import '../../models/estudos_biblicos_model.dart';
import '../../databases/estudos_dao.dart';
import '../../models/matricula_model.dart';
import '../../databases/matriculas_dao.dart';
import '../alunos/aluno_painel_screen.dart';
import '../../services/firebase_matricula_service.dart';

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

  void _confirmarMatricula() async {
    if (_indiceSelecionado == null) return;

    final estudoSelecionado = estudos[_indiceSelecionado!];
    final idEstudo = estudoSelecionado.id;
    final idAluno = widget.idAluno;
    final dataAtual = DateTime.now().toIso8601String();

    final novaMatricula = MatriculaModel(
      idUsuario: idAluno,
      idEstudoBiblico: idEstudo,
      dataMatricula: dataAtual,
    );

    // 1. Salva localmente
    await MatriculaDao().insertMatricula(novaMatricula);

    // 2. Sincroniza com Firebase
    await FirebaseMatriculaService.sincronizarMatriculas();

    // 3. Mostra confirmação e navega
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Aluno matriculado em ${estudoSelecionado.nome}')),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => AlunoPainel(idAluno: idAluno, idEstudo: idEstudo),
      ),
    );
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
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TitleWidget(
                    name: 'Selecione um estudo',
                    progress: 'Depois clique em "Matricular"',
                    bgColor: Colors.orangeAccent,
                    icon: Icons.info_outline,
                    centralizado: true,
                  ),
                  const SizedBox(height: 8),
                  GridView.builder(
                    padding: const EdgeInsets.only(bottom: 12),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: estudos.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  ButtonWidget(
                    label: 'Matricular Aluno',
                    backgroundColor: const Color(0xFF0B1121),
                    hoverColor: const Color(0xFF1F2A3F),
                    textColor: Colors.white,

                    onPressed: _confirmarMatricula,
                  ),
                ],
              ),
    );
  }
}
