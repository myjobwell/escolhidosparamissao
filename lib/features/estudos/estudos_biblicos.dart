import 'package:flutter/material.dart';
import '../../components/app_bar.dart';
import '../../components/FadeInWrapper.dart';
import '../../features/estudos/estudo_item_widget.dart'; // importa o widget e o modelo

class EstudosBiblicosPage extends StatefulWidget {
  const EstudosBiblicosPage({super.key});

  @override
  State<EstudosBiblicosPage> createState() => _EstudosBiblicosPageState();
}

class _EstudosBiblicosPageState extends State<EstudosBiblicosPage> {
  final List<EstudoItem> estudos = [
    EstudoItem("Ouvindo a Voz de Deus", "20 Lições", Icons.functions),
    EstudoItem("Revelações de Esperança", "20 Lições", Icons.sports_basketball),
    EstudoItem("Verdades Bíblicas", "20 Lições", Icons.headphones),
    EstudoItem("Em paz com Deus", "20 Lições", Icons.science),
    EstudoItem("Esperança para a Família", "20 Lições", Icons.palette),
    EstudoItem("O resgate da Verdade", "20 Lições", Icons.travel_explore),
  ];

  int? _indiceSelecionado = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1121),
      appBar: CustomAppBar(titulo: 'Meus estudos'),
      body: FadeInWrapper(
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.95,
                  ),
                  itemBuilder: (context, index) {
                    final item = estudos[index];
                    final bool selecionado = _indiceSelecionado == index;

                    return EstudoItemWidget(
                      item: item,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
