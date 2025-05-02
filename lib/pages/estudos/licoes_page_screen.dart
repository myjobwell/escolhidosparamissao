import 'package:flutter/material.dart';
import '../../models/estudos_biblicos_model.dart';
import '../../models/licoes_model.dart';
import '../../databases/estudos_dao.dart';
import '../../widgets/licao_item_widget.dart';
import '../../widgets/app_bar.dart';
import '../estudos/conteudos_screen.dart';
import '../../widgets/layout_page.dart';

class LicoesPage extends StatefulWidget {
  final int estudoId;

  const LicoesPage({super.key, required this.estudoId});

  @override
  State<LicoesPage> createState() => _LicoesPageState();
}

class _LicoesPageState extends State<LicoesPage> {
  List<Licao> licoes = [];
  EstudoBiblico? estudo;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    final estudos = await DbEstudos.listarEstudos();
    estudo = estudos.firstWhere(
      (e) => e.id == widget.estudoId,
      orElse: () => EstudoBiblico(id: 0, nome: 'Estudo'),
    );

    licoes = await DbEstudos.listarLicoesPorEstudo(widget.estudoId);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      titulo: estudo?.nome ?? 'Lições',
      isLoading: isLoading,
      child: Column(
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
              concluida: true,
            ),
          );
        }),
      ),
    );
  }
}
