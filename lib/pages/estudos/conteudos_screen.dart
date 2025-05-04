import 'package:flutter/material.dart';
import '../../models/conteudo_model.dart';
import '../../widgets/app_bar.dart';
import '../../databases/estudos_dao.dart';
import '../../widgets/layout_page.dart';

class ConteudosPage extends StatefulWidget {
  final int idLicao;
  final String tituloLicao;

  const ConteudosPage({
    super.key,
    required this.idLicao,
    required this.tituloLicao,
  });

  @override
  State<ConteudosPage> createState() => _ConteudosPageState();
}

class _ConteudosPageState extends State<ConteudosPage> {
  List<Conteudo> conteudos = [];
  List<bool> expandido = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    carregarConteudos();
  }

  Future<void> carregarConteudos() async {
    final resultado = await DbEstudos.listarConteudosPorLicao(widget.idLicao);
    setState(() {
      conteudos = resultado;
      expandido = List.generate(conteudos.length, (index) => index == 0);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      titulo: 'Lição | ${widget.tituloLicao}',
      isLoading: isLoading,
      child: ListView.separated(
        shrinkWrap: true,
        physics:
            const NeverScrollableScrollPhysics(), // evita conflito com scroll do BasePage
        itemCount: conteudos.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = conteudos[index];
          final aberto = expandido[index];

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      expandido[index] = !expandido[index];
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            color: Color(0xFF0B1121),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item.pergunta,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          aberto ? Icons.expand_less : Icons.expand_more,
                          color: Colors.grey.shade600,
                        ),
                      ],
                    ),
                  ),
                ),
                if (aberto)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Text(
                      item.resposta,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
