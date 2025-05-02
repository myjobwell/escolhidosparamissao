import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/button.dart';
import '../usuario/usuario_cadastro_screen.dart';
import '../../utils/masks.dart';
import '../professor/principal_professor_screen.dart';
import '../../core/global.dart';
import '../../models/usuario_model.dart';
import '../../databases/db_usuario.dart';
import '../../databases/db_estudos.dart';
import '../loading/loading_page.dart';

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
            // Elementos decorativos
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

                  // Área de login
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

                        // Botão de login
                        ButtonWidget(
                          label: 'Acessar',
                          backgroundColor: const Color(0xFF0B1121),
                          hoverColor: const Color(0xFF1F2A3F),
                          textColor: Colors.white,
                          /*
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

                            // Mostra loading
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder:
                                  (_) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                            );

                            try {
                              final usuarioFirebase =
                                  await _buscarUsuarioNoFirebase(cpfLimpo);
                              if (usuarioFirebase == null) {
                                Navigator.of(context).pop(); // Fecha loading
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
                                await DbUsuario.salvarUsuario(usuarioFirebase);
                              }

                              // Armazenando o CPF logado globalmente
                              cpfLogado = cpfLimpo;

                              final usuario =
                                  await DbUsuario.buscarUsuarioPorCpf(
                                    cpfLogado!,
                                  );
                              if (usuario != null) {
                                nomeUsuarioGlobal = usuario.nome;
                                uniaoIdGlobal = usuario.uniaoId;
                                uniaoNomeGlobal = usuario.uniaoNome;
                                associacaoIdGlobal = usuario.associacaoId;
                                associacaoNomeGlobal = usuario.associacaoNome;
                                distritoIdGlobal = usuario.distritoId;
                                distritoNomeGlobal = usuario.distritoNome;
                                igrejaIdGlobal = usuario.igrejaId;
                                igrejaNomeGlobal = usuario.igrejaNome;
                              }

                              // Verificar se as variáveis globais estão setadas corretamente
                              if (uniaoIdGlobal == null ||
                                  uniaoNomeGlobal == null ||
                                  associacaoIdGlobal == null ||
                                  associacaoNomeGlobal == null ||
                                  distritoIdGlobal == null ||
                                  distritoNomeGlobal == null ||
                                  igrejaIdGlobal == null ||
                                  igrejaNomeGlobal == null ||
                                  cpfLogado == null) {
                                // Print com os valores das variáveis globais
                                print(
                                  'Erro: As variáveis globais não estão setadas corretamente.',
                                );
                                print('uniaoIdGlobal: $uniaoIdGlobal');
                                print('uniaoNomeGlobal: $uniaoNomeGlobal');
                                print(
                                  'associacaoIdGlobal: $associacaoIdGlobal',
                                );
                                print(
                                  'associacaoNomeGlobal: $associacaoNomeGlobal',
                                );
                                print('distritoIdGlobal: $distritoIdGlobal');
                                print(
                                  'distritoNomeGlobal: $distritoNomeGlobal',
                                );
                                print('igrejaIdGlobal: $igrejaIdGlobal');
                                print('igrejaNomeGlobal: $igrejaNomeGlobal');
                                print('cpfLogado: $cpfLogado');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Erro: Variáveis globais não configuradas corretamente.',
                                    ),
                                  ),
                                );
                                return;
                              } else {
                                print(
                                  'Variáveis globais carregadas corretamente.',
                                );
                                print('uniaoIdGlobal: $uniaoIdGlobal');
                                print('uniaoNomeGlobal: $uniaoNomeGlobal');
                                print(
                                  'associacaoIdGlobal: $associacaoIdGlobal',
                                );
                                print(
                                  'associacaoNomeGlobal: $associacaoNomeGlobal',
                                );
                                print('distritoIdGlobal: $distritoIdGlobal');
                                print(
                                  'distritoNomeGlobal: $distritoNomeGlobal',
                                );
                                print('igrejaIdGlobal: $igrejaIdGlobal');
                                print('igrejaNomeGlobal: $igrejaNomeGlobal');
                                print('cpfLogado: $cpfLogado');
                              }

                              await DbEstudos.sincronizarEstudosComApi();

                              Navigator.of(context).pop(); // Fecha loading

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const PageProfessor(),
                                ),
                              );
                            } catch (e) {
                              Navigator.of(context).pop(); // Fecha loading
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Erro ao acessar: $e')),
                              );
                            }
                          },
                          */
                          /*
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

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => LoadingPage(
                                      onLoadComplete: () async {
                                        final usuarioFirebase =
                                            await _buscarUsuarioNoFirebase(
                                              cpfLimpo,
                                            );
                                        if (usuarioFirebase == null) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Usuário não cadastrado, por favor crie uma conta.',
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        final usuarioLocal =
                                            await DbUsuario.buscarUsuarioPorCpf(
                                              cpfLimpo,
                                            );
                                        if (usuarioLocal == null) {
                                          await DbUsuario.salvarUsuario(
                                            usuarioFirebase,
                                          );
                                        }

                                        cpfLogado = cpfLimpo;

                                        final usuario =
                                            await DbUsuario.buscarUsuarioPorCpf(
                                              cpfLogado!,
                                            );
                                        if (usuario != null) {
                                          nomeUsuarioGlobal = usuario.nome;
                                          uniaoIdGlobal = usuario.uniaoId;
                                          uniaoNomeGlobal = usuario.uniaoNome;
                                          associacaoIdGlobal =
                                              usuario.associacaoId;
                                          associacaoNomeGlobal =
                                              usuario.associacaoNome;
                                          distritoIdGlobal = usuario.distritoId;
                                          distritoNomeGlobal =
                                              usuario.distritoNome;
                                          igrejaIdGlobal = usuario.igrejaId;
                                          igrejaNomeGlobal = usuario.igrejaNome;
                                        }

                                        await DbEstudos.sincronizarEstudosComApi();

                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (_) => const PageProfessor(),
                                          ),
                                        );
                                      },
                                    ),
                              ),
                            );
                          },
                          */
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

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => LoadingPage(
                                      onLoadComplete: () async {
                                        final usuarioFirebase =
                                            await _buscarUsuarioNoFirebase(
                                              cpfLimpo,
                                            );
                                        if (usuarioFirebase == null) {
                                          if (context.mounted) {
                                            Navigator.pop(
                                              context,
                                            ); // Fecha loading
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Usuário não cadastrado, por favor crie uma conta.',
                                                ),
                                              ),
                                            );
                                          }
                                          return;
                                        }

                                        final usuarioLocal =
                                            await DbUsuario.buscarUsuarioPorCpf(
                                              cpfLimpo,
                                            );
                                        if (usuarioLocal == null) {
                                          await DbUsuario.salvarUsuario(
                                            usuarioFirebase,
                                          );
                                        }

                                        cpfLogado = cpfLimpo;

                                        final usuario =
                                            await DbUsuario.buscarUsuarioPorCpf(
                                              cpfLogado!,
                                            );
                                        if (usuario != null) {
                                          nomeUsuarioGlobal = usuario.nome;
                                          uniaoIdGlobal = usuario.uniaoId;
                                          uniaoNomeGlobal = usuario.uniaoNome;
                                          associacaoIdGlobal =
                                              usuario.associacaoId;
                                          associacaoNomeGlobal =
                                              usuario.associacaoNome;
                                          distritoIdGlobal = usuario.distritoId;
                                          distritoNomeGlobal =
                                              usuario.distritoNome;
                                          igrejaIdGlobal = usuario.igrejaId;
                                          igrejaNomeGlobal = usuario.igrejaNome;
                                        }

                                        await DbEstudos.sincronizarEstudosComApi();
                                      },
                                    ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 15),

                        // Botão de cadastro
                        ButtonWidget(
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

  Future<Usuario?> _buscarUsuarioNoFirebase(String cpf) async {
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('usuarios')
              .doc(cpf)
              .get();
      if (!doc.exists) return null;

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
        idProfessor: data['id_professor'],
      );
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
