import 'package:flutter/material.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/FadeInWrapper.dart';
import '../../widgets/bloco_item_widget.dart';
import '../../models/estudos_biblicos_model.dart';
import '../../databases/db_estudos.dart';
import '../estudos/licoes_page_screen.dart'; // <- atualizado corretamente

class EstudosBiblicosPage extends StatefulWidget {
  const EstudosBiblicosPage({super.key});

  @override
  State<EstudosBiblicosPage> createState() => _EstudosBiblicosPageState();
}

class _EstudosBiblicosPageState extends State<EstudosBiblicosPage> {
  List<EstudoBiblico> estudos = [];
  bool isLoading = true;
  int? _indiceSelecionado;

  @override
  void initState() {
    super.initState();
    carregarEstudosDoBanco();
  }

  Future<void> carregarEstudosDoBanco() async {
    final dados = await DbEstudos.listarEstudos();
    setState(() {
      estudos = dados;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1121),
      appBar: CustomAppBar(titulo: 'Meus estudos'),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
              : FadeInWrapper(
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: GridView.builder(
                          itemCount: estudos.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: 0.95,
                              ),
                          itemBuilder: (context, index) {
                            final estudo = estudos[index];
                            final selecionado = _indiceSelecionado == index;

                            return BlocoItemWidget(
                              item: BlocoItem(
                                estudo.nome,
                                '20 Lições',
                                Icons.menu_book,
                              ),
                              selecionado: selecionado,
                              index: index,
                              onTap: () {
                                setState(() {
                                  _indiceSelecionado = index;
                                });

                                // ✅ Navegação segura para nova tela usando apenas o ID
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) =>
                                              LicoesPage(estudoId: estudo.id),
                                    ),
                                  );
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
