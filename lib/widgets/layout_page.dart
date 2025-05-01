import 'package:flutter/material.dart';
import '../widgets/app_bar.dart';
import '../widgets/decorated_background.dart'; // importa o fundo decorado

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
      backgroundColor: Colors.transparent,
      appBar: CustomAppBar(
        titulo: titulo,
        exibirBotaoVoltar: exibirBotaoVoltar,
        exibirSaudacao: exibirSaudacao,
        centralizarTitulo: centralizarTitulo,
        tamanhoTitulo: tamanhoTitulo,
      ),
      body: DecoratedBackground(
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child:
                    isLoading
                        ? const Center(
                          child: CircularProgressIndicator(color: Colors.black),
                        )
                        : SingleChildScrollView(child: child),
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Center(
                child: Text(
                  'ANRA/AC',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
