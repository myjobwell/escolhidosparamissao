import 'package:flutter/material.dart';

class HomeBackground extends StatelessWidget {
  const HomeBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(top: 80, left: 30, child: _circle(60, Colors.white12)),
        Positioned(top: 140, right: 50, child: _circle(16, Colors.white10)),
        Positioned(bottom: -40, left: -40, child: _circle(180, Colors.white12)),
        Positioned(bottom: 60, right: -20, child: _circle(80, Colors.white10)),
      ],
    );
  }

  static Widget _circle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
