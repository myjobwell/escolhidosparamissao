import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/hover_button_widget.dart';
import '../../usuario/pages/usuario_form_page.dart';
import '../../usuario/utils/masks.dart'; // ✅ Máscara de CPF
import '../../professor/page_professor.dart'; // Corrigido caminho
import '../../../core/global.dart'; // Variável global do CPF
import '../../../databases/app_database.dart'; // Banco de dados local
import '../../../models/usuario_model.dart'; // Modelo do usuário

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
            // Seus círculos de fundo
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

                            final usuarioFirebase =
                                await _buscarUsuarioNoFirebase(cpfLimpo);

                            if (usuarioFirebase == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Usuário não cadastrado, por favor crie uma conta.',
                                  ),
                                ),
                              );
                              return;
                            }

                            final usuarioLocal =
                                await DbUsuario.buscarUsuarioPorCpf(cpfLimpo);

                            if (usuarioLocal == null) {
                              // Salvar no banco local
                              await DbUsuario.salvarUsuario(usuarioFirebase);
                            }

                            cpfLogado = cpfLimpo;

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PageProfessor(),
                              ),
                            );
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

  // Função para buscar no Firebase e retornar Usuario (ou null)
  Future<Usuario?> _buscarUsuarioNoFirebase(String cpf) async {
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('usuarios')
              .doc(cpf)
              .get();

      if (doc.exists) {
        final data = doc.data();
        if (data == null) return null;

        return Usuario(
          id: data['id'] ?? cpf,
          nome: data['nome'] ?? '',
          cpf: cpf,
          sexo: data['sexo'] ?? '',
          telefone: data['telefone'] ?? '',
          email: data['email'] ?? '',
          nascimento: data['nascimento'] ?? '',
          tipoUsuario: data['tipo_usuario'] ?? '',
          divisaoId: data['divisaoId'] ?? 0,
          divisaoNome: data['divisaoNome'] ?? '',
          uniaoId: data['uniaoId'] ?? 0,
          uniaoNome: data['uniaoNome'] ?? '',
          associacaoId: data['associacaoId'] ?? 0,
          associacaoNome: data['associacaoNome'] ?? '',
          distritoId: data['distritoId'] ?? 0,
          distritoNome: data['distritoNome'] ?? '',
          igrejaId: data['igrejaId'] ?? '',
          igrejaNome: data['igrejaNome'] ?? '',
          sincronizado: true,
        );
      } else {
        return null;
      }
    } catch (e) {
      print('Erro ao buscar usuário: $e');
      return null;
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
