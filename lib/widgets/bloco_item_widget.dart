import 'package:flutter/material.dart';
import 'FadeInWrapper.dart';

//este bloco recebe o titulo, subtitulo e icone
// e exibe na tela

class BlocoItem {
  final String titulo;
  final String subtitulo;
  final IconData icon;

  BlocoItem(this.titulo, this.subtitulo, this.icon);
}

class BlocoItemWidget extends StatelessWidget {
  final BlocoItem item;
  final bool selecionado;
  final VoidCallback onTap;
  final int index;

  const BlocoItemWidget({
    super.key,
    required this.item,
    required this.selecionado,
    required this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInWrapper(
      duration: Duration(milliseconds: 200 + (index * 100)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            color:
                selecionado ? const Color(0xFF34D399) : const Color(0xFFF4F4F5),
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color:
                      selecionado
                          ? Colors.white.withOpacity(0.2)
                          : Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  item.icon,
                  size: 30,
                  color: selecionado ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                item.titulo,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: selecionado ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.subtitulo,
                style: TextStyle(
                  fontSize: 12,
                  color: selecionado ? Colors.white70 : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
