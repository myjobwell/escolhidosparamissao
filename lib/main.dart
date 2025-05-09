import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/home/home_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
