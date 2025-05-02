import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  final String name;
  final String progress;
  final Color bgColor;
  final IconData icon;
  final bool centralizado;

  const TitleWidget({
    super.key,
    required this.name,
    required this.progress,
    required this.bgColor,
    required this.icon,
    this.centralizado = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment:
          centralizado ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: bgColor,
          radius: 24,
          child: Icon(icon, color: Colors.black),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0B1121),
              ),
            ),
            Text(
              progress,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: centralizado ? Center(child: content) : content,
    );
  }
}
