import 'package:flutter/material.dart';
import '../../widgets/button.dart';
import '../../utils/masks.dart';
import '../../pages/usuario/usuario_cadastro_screen.dart';
import 'home_controller.dart';

class HomeLoginForm extends StatefulWidget {
  const HomeLoginForm({super.key});

  @override
  State<HomeLoginForm> createState() => _HomeLoginFormState();
}

class _HomeLoginFormState extends State<HomeLoginForm> {
  final TextEditingController _cpfController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/imgs/l_color_open.png',
          width: 300,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 8),
        const Text(
          'Ministério Pessoal | ANRA/AC',
          style: TextStyle(fontSize: 12, color: Colors.white),
        ),
        const SizedBox(height: 40),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Login',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B1121),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Entre ou crie uma conta para os\ndesafios missionários',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _cpfController,
                keyboardType: TextInputType.number,
                inputFormatters: [cpfFormatter],
                decoration: InputDecoration(
                  labelText: 'CPF',
                  hintText: 'Informe o seu CPF',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ButtonWidget(
                label: 'Acessar',
                backgroundColor: const Color(0xFF0B1121),
                hoverColor: const Color(0xFF1F2A3F),
                textColor: Colors.white,
                onPressed: () {
                  HomeController.login(context, _cpfController.text);
                },
              ),
              const SizedBox(height: 15),
              ButtonWidget(
                label: 'Criar uma conta',
                backgroundColor: const Color(0xFFE6E6E6),
                hoverColor: const Color(0xFFD0D0D0),
                textColor: const Color(0xFF0B1121),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const UsuarioFormPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
