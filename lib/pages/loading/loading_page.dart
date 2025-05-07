import 'package:flutter/material.dart';
import '../professor/home_painel_screen.dart';
import '../../widgets/background_home.dart';

class LoadingPage extends StatefulWidget {
  final Future<void> Function() onLoadComplete;

  const LoadingPage({super.key, required this.onLoadComplete});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    _iniciarCarregamento();
  }

  Future<void> _iniciarCarregamento() async {
    await Future.delayed(const Duration(seconds: 2));
    await widget.onLoadComplete();

    if (mounted) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomePainel()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BackgroundHome(
        child: SafeArea(
          child: SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment:
                  CrossAxisAlignment.center, // centraliza horizontalmente
              children: [
                const SizedBox(height: 10), // Espaço no topo (opcional)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/imgs/l_color_open.png',
                      width: 250,
                      height: 100,
                    ),
                    const SizedBox(height: 30),
                    const CircularProgressIndicator(color: Colors.white),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Image.asset(
                    'assets/imgs/my_logo.png', // imagem de rodapé
                    width: 120,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
