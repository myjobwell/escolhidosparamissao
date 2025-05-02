import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'services/sincronizacao_service.dart';
import 'pages/home/home_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Verifica conexão e sincroniza pendentes
  final connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult != ConnectivityResult.none) {
    await SincronizacaoService.sincronizarUsuariosPendentes();
  }

  runApp(const MipsApp());
}

class MipsApp extends StatelessWidget {
  const MipsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MIPS+',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}


/* import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/home/home_screen.dart';
import 'firebase_options.dart'; 
// Este arquivo é gerado pelo Firebase CLI

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options:
        DefaultFirebaseOptions
            .currentPlatform, // Requer configuração Firebase CLI
  );
  runApp(const MipsApp());
}

class MipsApp extends StatelessWidget {
  const MipsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MIPS+',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
 */