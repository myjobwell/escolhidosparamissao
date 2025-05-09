import 'package:flutter/material.dart';

class FirebaseOfflineScreen extends StatelessWidget {
  const FirebaseOfflineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            'Não foi possível conectar com o Firebase.\n\n'
            'Algumas funcionalidades podem estar indisponíveis.\n'
            'Verifique sua conexão ou tente novamente mais tarde.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
