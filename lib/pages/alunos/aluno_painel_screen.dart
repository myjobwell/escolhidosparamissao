import 'package:flutter/material.dart';
import '../../widgets/layout_page.dart';
import '../../widgets/aluno_dashboard_widget.dart';
import '../../widgets/licao_item_widget.dart';
import '../../models/licoes_model.dart';
import '../../databases/estudos_dao.dart';
import '../estudos/conteudos_screen.dart';

class AlunoPainel extends StatelessWidget {
  final String idAluno;
  final int idEstudo;

  const AlunoPainel({super.key, required this.idAluno, required this.idEstudo});

  final int estudoId = 1; // fixo, pode ser tornado dinâmico depois

  @override
  Widget build(BuildContext context) {
    return BasePage(
      titulo: 'Painel do Aluno',
      isLoading: false,
      exibirBotaoVoltar: true,
      exibirSaudacao: true,
      centralizarTitulo: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StudyCard(
            title: 'Ouvindo a Voz de Deus',
            completedLessons: 8,
            totalLessons: 20,
          ),
          const SizedBox(height: 12),
          const Text(
            'Lições',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          FutureBuilder<List<Licao>>(
            future: DbEstudos.listarLicoesPorEstudo(estudoId),
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
