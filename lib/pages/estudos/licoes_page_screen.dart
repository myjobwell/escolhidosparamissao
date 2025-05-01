import 'package:flutter/material.dart';
import '../../models/estudos_biblicos_model.dart';
import '../../models/licoes_model.dart';
import '../../databases/db_estudos.dart';
import '../../widgets/licao_item_widget.dart';
import '../../widgets/app_bar.dart';

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
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: CustomAppBar(titulo: estudo?.nome ?? 'Lições'),
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
                    concluida: index < 8,
                  );
                },
              ),
    );
  }
}
