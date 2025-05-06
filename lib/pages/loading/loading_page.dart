import 'package:flutter/material.dart';
import '../professor/principal_professor_screen.dart';
import '../professor/home_painel_screen.dart';

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
        //🚩add um novo redirecionamento enquanto trabalho em melhorias
        //MaterialPageRoute(builder: (_) => const PageProfessor()),
        MaterialPageRoute(builder: (_) => const HomePainel()),
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
