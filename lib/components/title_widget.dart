import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  final String name;
  final String progress;
  final Color bgColor;

  const TitleWidget({
    super.key,
    required this.name,
    required this.progress,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: bgColor,
            radius: 24,
            child: const Icon(Icons.person, color: Colors.black),
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
      ),
    );
  }
}
