import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LicaoItemWidget extends StatelessWidget {
  final int numero;
  final String titulo;
  final int concluido; // ✅ agora é inteiro
  final VoidCallback? onTituloTap;
  final VoidCallback? onConcluirTap;

  const LicaoItemWidget({
    super.key,
    required this.numero,
    required this.titulo,
    required this.concluido, // ✅ recebido na criação
    this.onTituloTap,
    this.onConcluirTap,
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
            onTap: onConcluirTap,
            child: SvgPicture.asset(
              concluido == 1
                  ? 'assets/icons/hex_coroa_verde.svg'
                  : 'assets/icons/hex_coroa_cinza.svg',
              width: 28,
              height: 28,
            ),
          ),
        ],
      ),
    );
  }
}


/* import 'package:flutter/material.dart';
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
 */