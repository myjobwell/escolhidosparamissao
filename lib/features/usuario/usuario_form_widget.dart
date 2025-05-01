import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
//import 'package:mipsmais/core/firebase_usuario_service.dart';
//import 'package:mipsmais/databases/app_database.dart';
import 'package:mipsmais/services/firebase_usuario_service.dart'
    as core_firebase;
import '../../models/usuario_model.dart';
//import '../../services/firebase_usuario_service.dart';
//import '../../data/db_usuario.dart';
import 'utils/validators.dart';
import 'utils/masks.dart';
import 'widgets/campo_cpf_widget.dart';
import 'widgets/campo_telefone_widget.dart';
import 'widgets/campo_texto_widget.dart';
import 'widgets/dropdown_distrito_widget.dart';
import 'widgets/dropdown_igreja_widget.dart';
import 'widgets/campo_data_nascimento_widget.dart';
import 'widgets/campo_sexo_widget.dart';
import '../home/widgets/hover_button_widget.dart';
import '../../databases/db_usuario.dart';

class UsuarioFormWidget extends StatefulWidget {
  final Function()? onComplete;
  final Usuario? usuario;

  const UsuarioFormWidget({super.key, this.onComplete, this.usuario});

  @override
  State<UsuarioFormWidget> createState() => _UsuarioFormWidgetState();
}

class _UsuarioFormWidgetState extends State<UsuarioFormWidget> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nome;
  late TextEditingController _cpf;
  late TextEditingController _dataNascimento;
  late TextEditingController _telefone;

  String? _sexo;
  String? _selectedDistritoId;
  String? _selectedDistritoNome;
  String? _selectedIgrejaId;
  String? _selectedIgrejaNome;

  List<Map<String, dynamic>> _distritos = [];
  List<Map<String, dynamic>> _igrejas = [];
  List<Map<String, dynamic>> _igrejasFiltradas = [];

  bool _cpfDuplicado = false;
  bool _formFoiEnviado = false;

  @override
  void initState() {
    super.initState();
    final u = widget.usuario;
    _nome = TextEditingController(text: u?.nome);
    _cpf = TextEditingController(text: u?.cpf);
    _dataNascimento = TextEditingController(
      text: u != null ? _formatarDataNascimento(u.nascimento) : '',
    );
    _telefone = TextEditingController(text: u?.telefone.toString());
    _sexo = u?.sexo;

    _loadDistritos();
    _loadIgrejas();

    if (u != null) {
      _selectedDistritoNome = u.distritoNome;
      _selectedIgrejaId = u.igrejaId;
      _selectedIgrejaNome = u.igrejaNome;
    }
  }

  String _formatarDataNascimento(String nascimentoIso) {
    try {
      final nascimento = DateTime.parse(nascimentoIso);
      return "${nascimento.day.toString().padLeft(2, '0')}/"
          "${nascimento.month.toString().padLeft(2, '0')}/"
          "${nascimento.year}";
    } catch (e) {
      return '';
    }
  }

  String _converterDataParaIso(String dataBr) {
    try {
      final partes = dataBr.split('/');
      final dia = int.parse(partes[0]);
      final mes = int.parse(partes[1]);
      final ano = int.parse(partes[2]);
      final data = DateTime(ano, mes, dia);
      return data.toIso8601String();
    } catch (e) {
      return '';
    }
  }

  Future<void> _loadDistritos() async {
    final String response = await rootBundle.loadString(
      'assets/distritos.json',
    );
    final List<dynamic> data = jsonDecode(response);

    setState(() {
      _distritos =
          data
              .map((e) => {'id': e['idDISTRITO'].toString(), 'nome': e['NOME']})
              .toList();
    });
  }

  Future<void> _loadIgrejas() async {
    final String response = await rootBundle.loadString('assets/igrejas.json');
    final List<dynamic> data = jsonDecode(response);

    setState(() {
      _igrejas =
          data
              .map(
                (e) => {
                  'id': e['idIGREJA'].toString(),
                  'nome': e['NOME'],
                  'distritoId': e['distritoId'].toString(),
                },
              )
              .toList();
    });
  }

  void _filtrarIgrejasPorDistrito(String distritoId) {
    setState(() {
      _igrejasFiltradas =
          _igrejas
              .where((igreja) => igreja['distritoId'] == distritoId)
              .toList();
    });
  }

  Future<void> _cadastrarUsuario() async {
    setState(() => _formFoiEnviado = true);

    if (_formKey.currentState!.validate() && _isFormValido()) {
      final nascimentoIso = _converterDataParaIso(_dataNascimento.text);

      Usuario usuario = Usuario(
        id: _cpf.text,
        nome: _nome.text,
        cpf: _cpf.text.replaceAll(RegExp(r'[^0-9]'), ''),
        nascimento: nascimentoIso,
        sexo: _sexo ?? '',
        telefone: telefoneFormatter.getUnmaskedText(),
        email: '',
        tipoUsuario: 'Professor',
        divisaoId: 1,
        divisaoNome: 'Divisão Sul Americana (DSA)',
        uniaoId: 1,
        uniaoNome: 'União Noroeste Brasileira (UNoB)',
        associacaoId: 1,
        associacaoNome: 'Associação Norte Rondônia e Acre (ANRA)',
        distritoId: int.tryParse(_selectedDistritoId ?? '') ?? 0,
        distritoNome: _selectedDistritoNome ?? '',
        igrejaId: _selectedIgrejaId ?? '',
        igrejaNome: _selectedIgrejaNome ?? '',
        sincronizado: false,
      );

      await DbUsuario.salvarUsuario(usuario);
      bool sucessoFirebase = await core_firebase
          .FirebaseUsuarioService.salvarUsuario(usuario);

      if (sucessoFirebase) {
        await DbUsuario.atualizarSincronizacao(usuario.cpf);
      }

      if (widget.onComplete != null) {
        widget.onComplete!();
      }
    }
  }

  bool _isFormValido() {
    return !_cpfDuplicado &&
        _nome.text.isNotEmpty &&
        _cpf.text.length == 14 &&
        validarCpf(_cpf.text) &&
        _dataNascimento.text.length == 10 &&
        _selectedDistritoNome != null &&
        _selectedIgrejaId != null &&
        _sexo != null &&
        _telefone.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
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
            CampoCpfWidget(
              controller: _cpf,
              onCpfCheck:
                  (duplicado) => setState(() => _cpfDuplicado = duplicado),
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
            const SizedBox(height: 16),
            DropdownDistritoWidget(
              selectedId: _selectedDistritoId,
              distritos: _distritos,
              onChanged: (value) {
                final nome =
                    _distritos.firstWhere((d) => d['id'] == value)['nome'];
                setState(() {
                  _selectedDistritoId = value;
                  _selectedDistritoNome = nome;
                  _selectedIgrejaId = null;
                  _selectedIgrejaNome = null;
                });
                if (value != null) {
                  _filtrarIgrejasPorDistrito(value);
                }
              },
              showErrors: _formFoiEnviado,
            ),
            const SizedBox(height: 16),
            DropdownIgrejaWidget(
              selectedId: _selectedIgrejaId,
              igrejas: _igrejasFiltradas,
              onChanged: (value) {
                final nome =
                    _igrejasFiltradas.firstWhere(
                      (i) => i['id'] == value,
                    )['nome'];
                setState(() {
                  _selectedIgrejaId = value;
                  _selectedIgrejaNome = nome;
                });
              },
              showErrors: _formFoiEnviado,
            ),
            const SizedBox(height: 20),
            Center(
              child: HoverButtonWidget(
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
    );
  }
}
