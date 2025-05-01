import 'package:flutter/material.dart';
import '../../core/global.dart';
import 'FadeInWrapper.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;
  final bool exibirSaudacao;
  final bool exibirBotaoVoltar;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onBackTap;

  const CustomAppBar({
    super.key,
    required this.titulo,
    this.exibirSaudacao = true,
    this.exibirBotaoVoltar = true,
    this.onSettingsTap,
    this.onBackTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(110);

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.only(top: topPadding, left: 16, right: 16, bottom: 8),
      color: const Color(0xFF0B1121),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Primeira linha: Saudação + configurações
          if (exibirSaudacao)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(child: FadeInWrapper(child: _WelcomeText())),
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  onPressed: onSettingsTap,
                ),
              ],
            ),

          if (exibirSaudacao) const SizedBox(height: 4),

          /// Segunda linha: seta à esquerda e título centralizado
          Stack(
            alignment: Alignment.center,
            children: [
              if (exibirBotaoVoltar)
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 20,
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: onBackTap ?? () => Navigator.of(context).pop(),
                  ),
                ),
              Center(
                child: Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WelcomeText extends StatelessWidget {
  const _WelcomeText();

  @override
  Widget build(BuildContext context) {
    final nome = nomeUsuarioGlobal ?? '';

    return RichText(
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          const TextSpan(
            text: 'Bem-vindo! ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          TextSpan(
            text: nome,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
