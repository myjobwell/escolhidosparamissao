import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/home/home_page.dart';
import 'services/sincronizacao_auto_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Inicia o escutador de rede que sincroniza automaticamente
  SincronizacaoAutoService.iniciar();

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
