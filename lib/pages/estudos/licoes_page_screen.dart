import 'package:flutter/material.dart';
import '../../models/estudos_biblicos_model.dart';
import '../../models/licoes_model.dart';
import '../../databases/db_estudos.dart';
import '../../widgets/licao_item_widget.dart';
import '../../widgets/app_bar.dart';

class LicoesPage extends StatefulWidget {
  final EstudoBiblico estudo;

  const LicoesPage({super.key, required this.estudo});

  @override
  State<LicoesPage> createState() => _LicoesPageState();
}

class _LicoesPageState extends State<LicoesPage> {
  List<Licao> licoes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    carregarLicoes();
  }

  Future<void> carregarLicoes() async {
    final resultado = await DbEstudos.listarLicoesPorEstudo(widget.estudo.id);
    setState(() {
      licoes = resultado;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: CustomAppBar(titulo: widget.estudo.nome),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: licoes.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final licao = licoes[index];
                  return LicaoItemWidget(
                    numero: index + 1,
                    titulo: licao.nome,
                    concluida: index < 8, // lógica de exemplo
                  );
                },
              ),
    );
  }
}
