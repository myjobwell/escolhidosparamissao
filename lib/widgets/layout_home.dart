import 'package:flutter/material.dart';
import '../widgets/background_home.dart';
import '../widgets/app_bar_home.dart';

class BasePageHome extends StatelessWidget {
  final String titulo;
  final bool isLoading;
  final Widget child;
  final String nomeUsuario;

  const BasePageHome({
    super.key,
    required this.titulo,
    required this.isLoading,
    required this.child,
    required this.nomeUsuario,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackgroundHome(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBarHome(nomeUsuario: nomeUsuario),

            // 🖼️ Imagem PNG centralizada (sem texto)
            const Padding(
              padding: EdgeInsets.only(top: 2), // 📏 ajuste vertical da imagem
              child: Center(
                child: Image(
                  image: AssetImage('assets/imgs/logoEscolhidos.png'),
                  width: 250,
                  height: 180,
                ),
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child:
                  isLoading
                      ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                      : SingleChildScrollView(child: child),
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
