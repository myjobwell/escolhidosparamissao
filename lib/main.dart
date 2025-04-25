import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'features/home/pages/home_page.dart';
import 'firebase_options.dart'; // Este arquivo é gerado pelo Firebase CLI

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
