import 'package:flutter/material.dart';

class DecoratedBackground extends StatelessWidget {
  final Widget child;

  const DecoratedBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF060B18), // quase preto (topo)
            Color(0xFF1E2E4C), // azul escuro intenso (base)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Positioned(top: 80, left: 30, child: _circle(60, Colors.white12)),
          Positioned(top: 140, right: 50, child: _circle(16, Colors.white10)),
          Positioned(
            top: 250,
            left: 180,
            child: _circle(12, Colors.purpleAccent),
          ),
          Positioned(
            bottom: -40,
            left: -40,
            child: _circle(180, Colors.white12),
          ),
          Positioned(
            bottom: 60,
            right: -20,
            child: _circle(80, Colors.white10),
          ),
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
}
