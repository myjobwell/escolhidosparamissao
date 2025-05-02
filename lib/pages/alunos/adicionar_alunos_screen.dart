import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../models/usuario_model.dart';
import '../../services/firebase_usuario_service.dart' as core_firebase;
import '../../utils/validators.dart';
import '../../utils/masks.dart';
import '../../widgets/forms_widgets/campo_telefone_widget.dart';
import '../../widgets/forms_widgets/campo_texto_widget.dart';
import '../../widgets/forms_widgets/campo_data_nascimento_widget.dart';
import '../../widgets/forms_widgets/campo_sexo_widget.dart';
import '../../widgets/button.dart';
import '../../databases/usuario_dao.dart';
import '../../widgets/layout_page.dart';
import '../../core/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdicionarAlunoPage extends StatefulWidget {
  const AdicionarAlunoPage({super.key});

  @override
  State<AdicionarAlunoPage> createState() => _AdicionarAlunoPageState();
}

class _AdicionarAlunoPageState extends State<AdicionarAlunoPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nome;
  late TextEditingController _dataNascimento;
  late TextEditingController _telefone;

  String? _sexo;
  bool _formFoiEnviado = false;

  @override
  void initState() {
    super.initState();
    _nome = TextEditingController();
    _dataNascimento = TextEditingController();
    _telefone = TextEditingController();
  }

  String _converterDataParaIso(String dataBr) {
    try {
      final partes = dataBr.split('/');
      final dia = int.parse(partes[0]);
      final mes = int.parse(partes[1]);
      final ano = int.parse(partes[2]);
      return DateTime(ano, mes, dia).toIso8601String();
    } catch (_) {
      return '';
    }
  }

  bool _isFormValido() {
    return _nome.text.isNotEmpty && _sexo != null;
  }

  Future<void> _cadastrarUsuario() async {
    setState(() => _formFoiEnviado = true);

    if (_formKey.currentState!.validate() && _isFormValido()) {
      final nascimentoIso = _converterDataParaIso(_dataNascimento.text);
      final uuid = const Uuid();

      // Gerar o UUID como ID único
      final String idFinal = uuid.v4(); // Gerar UUID aqui

      // 🚨 DEBUG: Verificar o ID gerado
      print('🔍 ID gerado com uuid.v4(): $idFinal');

      // Verifique se o idFinal está correto
      if (idFinal.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro: ID gerado está vazio.')),
        );
        return;
      }

      // Criação do usuário com o ID gerado automaticamente
      final usuario = Usuario(
        id: idFinal, // ID gerado automaticamente
        nome: _nome.text,
        cpf: "", // Não estamos mais usando o CPF
        nascimento: nascimentoIso,
        sexo: _sexo ?? '',
        telefone: telefoneFormatter.getUnmaskedText(),
        email: '',
        tipoUsuario: 'Aluno',
        divisaoId: 1,
        divisaoNome: 'Divisão Sul Americana (DSA)',
        uniaoId: uniaoIdGlobal!,
        uniaoNome: uniaoNomeGlobal!,
        associacaoId: associacaoIdGlobal!,
        associacaoNome: associacaoNomeGlobal!,
        distritoId: distritoIdGlobal!,
        distritoNome: distritoNomeGlobal!,
        igrejaId: igrejaIdGlobal!,
        igrejaNome: igrejaNomeGlobal!,
        sincronizado: false,
        idProfessor: cpfLogado, // O idProfessor pode ser o cpfLogado
      );

      // 🚨 DEBUG: Verificar o ID dentro do objeto usuario
      print('🧾 usuario.id: ${usuario.id}');

      // Salvar o usuário no banco de dados local
      await DbUsuario.salvarUsuario(usuario);

      // Tentar salvar o usuário no Firebase
      /*
      bool sucessoFirebase = await core_firebase
          .FirebaseUsuarioService.salvarUsuario(usuario);
      */
      // Tentar salvar o usuário no Firebase
      bool sucessoFirebase = await core_firebase
          .FirebaseUsuarioService.salvarUsuario(usuario);

      /* if (sucessoFirebase) {
        // Se a operação no Firebase for bem-sucedida, atualiza a sincronização
        await DbUsuario.atualizarSincronizacao(usuario.id);
      } */
      if (sucessoFirebase) {
        // Atualiza sincronizado = 1 no Firebase
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(usuario.id)
            .update({'sincronizado': 1});

        // Atualiza sincronizado = 1 no banco local
        await DbUsuario.atualizarSincronizacao(usuario.id);
      }

      Navigator.pop(context); // Voltar para a tela anterior
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      titulo: 'Adicionar Aluno',
      isLoading: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CampoTextoWidget(
                controller: _nome,
                label: 'Nome',
                validator: (value) {
                  if (!_formFoiEnviado) return null;
                  if (value == null || value.isEmpty) return 'Informe o nome';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CampoDataNascimentoWidget(
                controller: _dataNascimento,
                showErrors: _formFoiEnviado,
              ),
              const SizedBox(height: 16),
              CampoTelefoneWidget(
                controller: _telefone,
                showErrors: _formFoiEnviado,
              ),
              CampoSexoWidget(
                selectedSexo: _sexo,
                onChanged: (value) => setState(() => _sexo = value),
                showErrors: _formFoiEnviado,
              ),
              const SizedBox(height: 20),
              Center(
                child: ButtonWidget(
                  label: 'Cadastrar',
                  backgroundColor: const Color(0xFF0B1121),
                  hoverColor: const Color(0xFF1F2A3F),
                  textColor: Colors.white,
                  onPressed: _cadastrarUsuario,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
