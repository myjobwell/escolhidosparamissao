import 'package:flutter/material.dart';
import '../widgets/decorated_background.dart';
import '../widgets/app_bar.dart'; // Certifique-se de importar o CustomAppBar

class BasePage extends StatelessWidget {
  final String titulo;
  final bool isLoading;
  final Widget child;
  final bool exibirBotaoVoltar;
  final bool exibirSaudacao;
  final bool centralizarTitulo;
  final double? tamanhoTitulo;
  final VoidCallback? onVoltarCustomizado;

  const BasePage({
    super.key,
    required this.titulo,
    required this.isLoading,
    required this.child,
    this.exibirBotaoVoltar = true,
    this.exibirSaudacao = true,
    this.centralizarTitulo = false,
    this.tamanhoTitulo,
    this.onVoltarCustomizado,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar:
          exibirSaudacao
              ? CustomAppBar(
                titulo: titulo,
                exibirSaudacao: exibirSaudacao,
                exibirBotaoVoltar: exibirBotaoVoltar,
                onBackTap: onVoltarCustomizado,
                tamanhoTitulo: tamanhoTitulo,
                centralizarTitulo: centralizarTitulo,
              )
              : AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: centralizarTitulo,
                automaticallyImplyLeading: false,
                leading:
                    exibirBotaoVoltar
                        ? IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                          onPressed:
                              onVoltarCustomizado ??
                              () => Navigator.of(context).pop(),
                        )
                        : null,
                title: Text(
                  titulo,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontSize: tamanhoTitulo ?? 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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




/* import 'package:flutter/material.dart';
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
 */