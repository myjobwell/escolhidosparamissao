import 'package:flutter/material.dart';
import '../../core/global.dart';
import '../widgets/FadeInWrapper.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;
  final bool exibirSaudacao;
  final bool exibirBotaoVoltar;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onBackTap;
  final double? tamanhoTitulo;
  final bool centralizarTitulo;

  const CustomAppBar({
    super.key,
    required this.titulo,
    this.exibirSaudacao = true,
    this.exibirBotaoVoltar = true,
    this.onSettingsTap,
    this.onBackTap,
    this.tamanhoTitulo,
    this.centralizarTitulo = false,
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

          Stack(
            alignment: Alignment.center,
            children: [
              if (exibirBotaoVoltar)
                Positioned(
                  left: 0,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 20,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: onBackTap ?? () => Navigator.of(context).pop(),
                  ),
                ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: exibirBotaoVoltar ? 40 : 0,
                ),
                child: Text(
                  titulo,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: tamanhoTitulo ?? 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
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
