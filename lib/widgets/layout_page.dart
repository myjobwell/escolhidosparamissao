import 'package:flutter/material.dart';
import 'app_bar.dart';

class BasePage extends StatelessWidget {
  final String titulo;
  final bool isLoading;
  final Widget child;

  const BasePage({
    super.key,
    required this.titulo,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1121),
      appBar: CustomAppBar(titulo: titulo),
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
