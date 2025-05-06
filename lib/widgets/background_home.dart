import 'package:flutter/material.dart';

class BackgroundHome extends StatelessWidget {
  final Widget child;

  const BackgroundHome({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0B1121),
      child: Stack(
        children: [
          // Círculo superior esquerdo - mais alto
          Positioned(
            top: 80,
            left: 20,
            child: _circleWithBorder(100, Colors.white12, Colors.transparent),
          ),
          Positioned(
            top: 110,
            left: 60,
            child: _circle(40, const Color(0xFF1E2233)),
          ),
          Positioned(
            top: 130,
            left: 120,
            child: _circle(10, const Color(0xFF7A75FF)),
          ),

          // Círculo superior direito - mais abaixo e separado
          Positioned(
            top: 220,
            right: 20,
            child: _circleWithBorder(120, Colors.white10, Colors.transparent),
          ),
          Positioned(
            top: 260,
            right: 50,
            child: _circle(40, const Color(0xFF1E2233)),
          ),
          Positioned(
            top: 290,
            right: 100,
            child: _circle(10, const Color(0xFF7A75FF)),
          ),

          // Círculo inferior esquerdo
          Positioned(
            bottom: -60,
            left: -60,
            child: _circleWithBorder(200, Colors.white12, Colors.transparent),
          ),

          // Círculo inferior direito
          Positioned(
            bottom: 50,
            right: -20,
            child: _circle(80, Colors.white10),
          ),

          // Conteúdo da página
          child,
        ],
      ),
    );
  }

  Widget _circle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  Widget _circleWithBorder(double size, Color borderColor, Color fillColor) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: fillColor,
        border: Border.all(color: borderColor, width: 1),
      ),
    );
  }
}
