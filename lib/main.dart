import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'presentation/pages/usuarios_page.dart'; // ← ESSA LINHA FALTAVA

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Usuários',
      home: UserCrudPage(), // ← FUNCIONA AGORA
    );
  }
}




/*
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'presentation/pages/igreja_filter_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Filtro de Igrejas',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const IgrejaFilterPage(),
    );
  }
}
*/