import 'package:flutter/material.dart';
import 'home_background.dart';
import 'home_login_form.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1121),
      body: const SafeArea(
        child: Stack(
          children: [HomeBackground(), Center(child: HomeLoginForm())],
        ),
      ),
    );
  }
}


/* import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../widgets/button.dart';
import '../usuario/usuario_cadastro_screen.dart';
import '../../utils/masks.dart';
import '../../core/global.dart';
import '../../databases/usuario_dao.dart';
import '../../databases/estudos_dao.dart';
import '../loading/loading_page.dart';
import '../../services/sincronizacao_service.dart';
import '../../services/firebase_usuario_service.dart';

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

                        ButtonWidget(
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

                            final connectivityResult =
                                await Connectivity().checkConnectivity();
                            final bool online =
                                connectivityResult != ConnectivityResult.none;

                            if (online) {
                              try {
                                print(
                                  '🔍 Online. Verificando CPF $cpfLimpo no Firebase...',
                                );
                                final usuarioFirebase =
                                    await FirebaseUsuarioService.buscarUsuarioPorCpf(
                                      cpfLimpo,
                                    );

                                if (usuarioFirebase == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Usuário não cadastrado. Crie uma conta.',
                                      ),
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
                                            await DbUsuario.salvarUsuario(
                                              usuarioFirebase,
                                            );
                                            print(
                                              '📥 Usuário salvo localmente.',
                                            );

                                            cpfLogado = cpfLimpo;

                                            final usuario =
                                                await DbUsuario.buscarUsuarioPorCpf(
                                                  cpfLogado!,
                                                );
                                            if (usuario != null) {
                                              nomeUsuarioGlobal = usuario.nome;
                                              uniaoIdGlobal = usuario.uniaoId;
                                              uniaoNomeGlobal =
                                                  usuario.uniaoNome;
                                              associacaoIdGlobal =
                                                  usuario.associacaoId;
                                              associacaoNomeGlobal =
                                                  usuario.associacaoNome;
                                              distritoIdGlobal =
                                                  usuario.distritoId;
                                              distritoNomeGlobal =
                                                  usuario.distritoNome;
                                              igrejaIdGlobal = usuario.igrejaId;
                                              igrejaNomeGlobal =
                                                  usuario.igrejaNome;
                                            }

                                            print('🔄 Sincronizando dados...');
                                            await SincronizacaoService.sincronizarTudo(
                                              cpfLimpo,
                                            );
                                            await DbEstudos.sincronizarEstudosComApi();
                                          },
                                        ),
                                  ),
                                );
                              } catch (e) {
                                print('❌ Erro na sincronização online: $e');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Erro ao sincronizar dados online.',
                                    ),
                                  ),
                                );
                              }
                            } else {
                              print('📴 Offline. Tentando acesso local...');
                              final usuarioLocal =
                                  await DbUsuario.buscarUsuarioPorCpf(cpfLimpo);
                              if (usuarioLocal == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Usuário não encontrado localmente.',
                                    ),
                                  ),
                                );
                                return;
                              }

                              cpfLogado = cpfLimpo;
                              nomeUsuarioGlobal = usuarioLocal.nome;
                              uniaoIdGlobal = usuarioLocal.uniaoId;
                              uniaoNomeGlobal = usuarioLocal.uniaoNome;
                              associacaoIdGlobal = usuarioLocal.associacaoId;
                              associacaoNomeGlobal =
                                  usuarioLocal.associacaoNome;
                              distritoIdGlobal = usuarioLocal.distritoId;
                              distritoNomeGlobal = usuarioLocal.distritoNome;
                              igrejaIdGlobal = usuarioLocal.igrejaId;
                              igrejaNomeGlobal = usuarioLocal.igrejaNome;

                              print('✅ Acesso local concedido.');

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => LoadingPage(
                                        onLoadComplete: () async {
                                          print(
                                            '🔂 Aguardando conexão futura para sincronizar.',
                                          );
                                        },
                                      ),
                                ),
                              );
                            }
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