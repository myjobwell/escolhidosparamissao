import 'package:flutter/material.dart';
import '../../widgets/FadeInWrapper.dart';
import '../../widgets/bloco_item_widget.dart';
import '../../models/estudos_biblicos_model.dart';
import '../../databases/estudos_dao.dart';
import '../../widgets/layout_page.dart';
import '../estudos/licoes_page_screen.dart';

class EstudosBiblicosPage extends StatefulWidget {
  const EstudosBiblicosPage({super.key});

  @override
  State<EstudosBiblicosPage> createState() => _EstudosBiblicosPageState();
}

class _EstudosBiblicosPageState extends State<EstudosBiblicosPage> {
  List<EstudoBiblico> estudos = [];
  Map<int, int> totalLicoesPorEstudo =
      {}; // ✅ Adicionado para armazenar contagem por estudo
  bool isLoading = true;
  int? _indiceSelecionado;

  @override
  void initState() {
    super.initState();
    carregarEstudosDoBanco();
  }

  Future<void> carregarEstudosDoBanco() async {
    final dados = await DbEstudos.listarEstudos();
    final Map<int, int> mapaLicoes = {}; // ✅ mapa para guardar as contagens

    // Para cada estudo, buscar total de lições
    for (final estudo in dados) {
      final licoes = await DbEstudos.listarLicoesPorEstudo(estudo.id);
      mapaLicoes[estudo.id] = licoes.length;
    }

    setState(() {
      estudos = dados;
      totalLicoesPorEstudo = mapaLicoes; // ✅ armazena as contagens
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      titulo: 'Meus estudos',
      isLoading: isLoading,
      child: FadeInWrapper(
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: estudos.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.95,
          ),
          itemBuilder: (context, index) {
            final estudo = estudos[index];
            final selecionado = _indiceSelecionado == index;

            final totalLicoes =
                totalLicoesPorEstudo[estudo.id] ??
                0; // ✅ busca a contagem correta
            final label = '$totalLicoes lições'; // ✅ texto dinâmico

            return BlocoItemWidget(
              item: BlocoItem(
                estudo.nome,
                label,
                Icons.menu_book,
              ), // ✅ valor atualizado
              selecionado: selecionado,
              index: index,
              onTap: () {
                setState(() {
                  _indiceSelecionado = index;
                });

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LicoesPage(estudoId: estudo.id),
                    ),
                  );
                });
              },
            );
          },
        ),
      ),
    );
  }
}


/* import 'package:flutter/material.dart';
import '../../widgets/FadeInWrapper.dart';
import '../../widgets/bloco_item_widget.dart';
import '../../models/estudos_biblicos_model.dart';
import '../../databases/estudos_dao.dart';
import '../../widgets/layout_page.dart';
import '../estudos/licoes_page_screen.dart';

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
    return BasePage(
      titulo: 'Meus estudos',
      isLoading: isLoading,
      child: FadeInWrapper(
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: estudos.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.95,
          ),
          itemBuilder: (context, index) {
            final estudo = estudos[index];
            final selecionado = _indiceSelecionado == index;

            return BlocoItemWidget(
              item: BlocoItem(estudo.nome, '20 Lições', Icons.menu_book),
              selecionado: selecionado,
              index: index,
              onTap: () {
                setState(() {
                  _indiceSelecionado = index;
                });

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LicoesPage(estudoId: estudo.id),
                    ),
                  );
                });
              },
            );
          },
        ),
      ),
    );
  }
}
 */