import 'package:flutter/material.dart';

class AppBarHome extends StatelessWidget {
  final String nomeUsuario;
  final VoidCallback? onSettingsTap;

  const AppBarHome({super.key, required this.nomeUsuario, this.onSettingsTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 20),
      child: Row(
        children: [
          // Texto de boas-vindas
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'BEM-VINDO!',
                  style: TextStyle(
                    color: Color(0xFFE6BFD8),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  nomeUsuario,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Ícone de configurações
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: onSettingsTap ?? () {},
            tooltip: 'Configurações',
          ),
        ],
      ),
    );
  }
}
