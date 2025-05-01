import 'package:flutter/material.dart';
import '../../models/estudos_biblicos_model.dart';
import '../../models/licoes_model.dart';
import '../../databases/db_estudos.dart';
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
    /*
    return Scaffold(
      backgroundColor: const Color(0xFF0B1121), // fundo por trás da AppBar
      appBar: CustomAppBar(titulo: estudo?.nome ?? 'Lições'),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white, // fundo branco da tela
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: SingleChildScrollView(
                  /*
                  child: Column(
                    children: List.generate(licoes.length, (index) {
                      final licao = licoes[index];
                      return LicaoItemWidget(
                        numero: index + 1,
                        titulo: licao.nome,
                        concluida: true,
                      );
                    }),
                  ),
                  */
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
                ),
              ),
    );
    */
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
