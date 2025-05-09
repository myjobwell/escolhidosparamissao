import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LicaoItemWidget extends StatelessWidget {
  final int numero;
  final String titulo;
  final int concluido; // 0 ou 1
  final Future<void> Function()? onConcluirTap;
  final VoidCallback? onTituloTap;

  const LicaoItemWidget({
    super.key,
    required this.numero,
    required this.titulo,
    required this.concluido,
    this.onConcluirTap,
    this.onTituloTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Text('$numero.', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: onTituloTap,
              child: Text(titulo, style: const TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () async {
              if (onConcluirTap != null) {
                await onConcluirTap!();
              }
            },
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder:
                  (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
              child: SvgPicture.asset(
                concluido == 1
                    ? 'assets/icons/hex_coroa_verde.svg'
                    : 'assets/icons/hex_coroa_cinza.svg',
                width: 28,
                height: 28,
                key: ValueKey(concluido), // 👈 necessário para animar troca
              ),
            ),
          ),
        ],
      ),
    );
  }
}
