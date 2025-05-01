import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LicaoItemWidget extends StatelessWidget {
  final int numero;
  final String titulo;
  final bool concluida;

  const LicaoItemWidget({
    super.key,
    required this.numero,
    required this.titulo,
    required this.concluida,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          // Número circular
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              numero.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          const SizedBox(width: 12),

          // Nome da lição
          Expanded(
            child: Text(
              titulo,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),

          // Ícone de progresso (hexágono com coroa)
          SvgPicture.asset(
            concluida
                ? 'assets/icons/hex_coroa_verde.svg'
                : 'assets/icons/hex_coroa_cinza.svg',
            width: 28,
            height: 28,
          ),
        ],
      ),
    );
  }
}
