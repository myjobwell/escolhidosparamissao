import 'package:flutter/material.dart';
import '../widgets/app_bar.dart';

class BasePage extends StatelessWidget {
  final String titulo;
  final bool isLoading;
  final Widget child;
  final bool exibirBotaoVoltar;
  final bool exibirSaudacao;
  final bool centralizarTitulo;
  final double? tamanhoTitulo;

  const BasePage({
    super.key,
    required this.titulo,
    required this.isLoading,
    required this.child,
    this.exibirBotaoVoltar = true,
    this.exibirSaudacao = true,
    this.centralizarTitulo = false,
    this.tamanhoTitulo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1121),
      appBar: CustomAppBar(
        titulo: titulo,
        exibirBotaoVoltar: exibirBotaoVoltar,
        exibirSaudacao: exibirSaudacao,
        centralizarTitulo: centralizarTitulo,
        tamanhoTitulo: tamanhoTitulo,
      ),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
              : Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: SingleChildScrollView(child: child),
              ),
    );
  }
}
