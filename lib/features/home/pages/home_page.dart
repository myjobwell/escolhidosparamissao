import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/hover_button_widget.dart';
import '../../usuario/pages/usuario_form_page.dart';
import '../../usuario/utils/masks.dart'; // ✅ Import do seu masks.dart

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _cpfController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFF0B1121),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(top: 80, left: 30, child: _circle(60, Colors.white12)),
            Positioned(top: 140, right: 50, child: _circle(16, Colors.white10)),
            Positioned(
              top: 250,
              left: 180,
              child: _circle(12, Colors.purpleAccent),
            ),
            Positioned(
              bottom: -40,
              left: -40,
              child: _circle(180, Colors.white12),
            ),
            Positioned(
              bottom: 60,
              right: -20,
              child: _circle(80, Colors.white10),
            ),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'MIPS+',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF43B74F),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Ministério de Pessoal +',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 80),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(
                      vertical: 30,
                      horizontal: 20,
                    ),
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

                        // ✅ Campo CPF com máscara aplicada
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

                        HoverButtonWidget(
                          label: 'Acessar',
                          backgroundColor: const Color(0xFF0B1121),
                          hoverColor: const Color(0xFF1F2A3F),
                          textColor: Colors.white,
                          onPressed: () async {
                            String cpfLimpo = _cpfController.text.replaceAll(
                              RegExp(r'[^0-9]'),
                              '',
                            );

                            if (cpfLimpo.isEmpty || cpfLimpo.length != 11) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Informe um CPF válido'),
                                ),
                              );
                              return;
                            }

                            bool usuarioExiste = await _verificarCpfNoFirebase(
                              cpfLimpo,
                            );

                            if (usuarioExiste) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Usuário cadastrado'),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Usuário não cadastrado, por favor crie uma conta',
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 15),
                        HoverButtonWidget(
                          label: 'Criar uma conta',
                          backgroundColor: const Color(0xFFE6E6E6),
                          hoverColor: const Color(0xFFD0D0D0),
                          textColor: const Color(0xFF0B1121),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const UsuarioFormPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Função para verificar no Firebase se o CPF existe
  Future<bool> _verificarCpfNoFirebase(String cpf) async {
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('usuarios')
              .doc(cpf)
              .get();
      return doc.exists;
    } catch (e) {
      print('Erro ao buscar usuário: $e');
      return false;
    }
  }

  Widget _circle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}



/* import 'package:flutter/material.dart';
import '../widgets/hover_button_widget.dart';
import '../../usuario/pages/usuario_form_page.dart'; // ✅ Import correto

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1121),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(top: 80, left: 30, child: _circle(60, Colors.white12)),
            Positioned(top: 140, right: 50, child: _circle(16, Colors.white10)),
            Positioned(
              top: 250,
              left: 180,
              child: _circle(12, Colors.purpleAccent),
            ),
            Positioned(
              bottom: -40,
              left: -40,
              child: _circle(180, Colors.white12),
            ),
            Positioned(
              bottom: 60,
              right: -20,
              child: _circle(80, Colors.white10),
            ),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'MIPS+',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF43B74F),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Ministério de Pessoal +',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 80),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(
                      vertical: 30,
                      horizontal: 20,
                    ),
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
                        HoverButtonWidget(
                          label: 'Login',
                          backgroundColor: const Color(0xFF0B1121),
                          hoverColor: const Color(0xFF1F2A3F),
                          textColor: Colors.white,
                          onPressed: () {}, // Temporariamente sem ação
                        ),
                        const SizedBox(height: 15),
                        HoverButtonWidget(
                          label: 'Criar uma conta',
                          backgroundColor: const Color(0xFFE6E6E6),
                          hoverColor: const Color(0xFFD0D0D0),
                          textColor: const Color(0xFF0B1121),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const UsuarioFormPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
 */