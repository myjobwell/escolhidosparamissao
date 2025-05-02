import 'package:flutter/material.dart';
import '../professor/principal_professor_screen.dart';

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
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const PageProfessor()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.hourglass_bottom, size: 80, color: Colors.black54),
            SizedBox(height: 30),
            CircularProgressIndicator(),
            SizedBox(height: 30),
            Text(
              'Desenvolvido por Wellington Silva',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}


/* import 'package:flutter/material.dart';

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
    // Tempo mínimo de exibição (pode ser ajustado)
    await Future.delayed(const Duration(seconds: 2));

    // Executa o carregamento enviado externamente
    await widget.onLoadComplete();

    // Garante que a tela está montada antes de seguir
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.hourglass_bottom, size: 80, color: Colors.black54),
            const SizedBox(height: 30),
            const CircularProgressIndicator(),
            const SizedBox(height: 30),
            const Text(
              'Desenvolvido por Wellington Silva',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
 */