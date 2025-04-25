import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/usuario_model.dart';
import 'utils/validators.dart';
import 'utils/masks.dart';
import 'widgets/campo_cpf_widget.dart';
import 'widgets/campo_telefone_widget.dart';
import 'widgets/dropdown_distrito_widget.dart';
import 'widgets/dropdown_igreja_widget.dart';
import 'widgets/campo_data_nascimento_widget.dart';
import 'widgets/campo_sexo_widget.dart';
import '../home/widgets/hover_button_widget.dart'; // ✅ botão estilizado

class UsuarioFormWidget extends StatefulWidget {
  final Function(Usuario usuario) onSubmit;
  final Usuario? usuario;

  const UsuarioFormWidget({super.key, required this.onSubmit, this.usuario});

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

  bool _cpfDuplicado = false;
  bool _formFoiEnviado = false;

  @override
  void initState() {
    final u = widget.usuario;
    _nome = TextEditingController(text: u?.nome);
    _cpf = TextEditingController(text: u?.cpf);
    _dataNascimento = TextEditingController(
      text:
          u != null
              ? "${u.dataNascimento.day.toString().padLeft(2, '0')}/"
                  "${u.dataNascimento.month.toString().padLeft(2, '0')}/"
                  "${u.dataNascimento.year}"
              : '',
    );
    _telefone = TextEditingController(text: u?.telefone.toString());
    _sexo = u?.sexo;

    _fetchDistritos();
    if (u != null) {
      _selectedDistritoNome = u.distrito;
      _selectedIgrejaId = u.igrejaId;
      _selectedIgrejaNome = u.nomeIgreja;
      _selectedDistritoId = null; // prevenimos quebra de seleção
    }
    super.initState();
  }

  Future<void> _fetchDistritos() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('distritos').get();
    setState(() {
      _distritos =
          snapshot.docs
              .map((doc) => {'id': doc.id, 'nome': doc['nome']})
              .toList();
    });
  }

  Future<void> _fetchIgrejas(String distritoId) async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('igrejas')
            .where('distritoId', isEqualTo: distritoId)
            .get();
    setState(() {
      _igrejas =
          snapshot.docs
              .map((doc) => {'id': doc.id, 'nome': doc['nome']})
              .toList();
    });
  }

  void _submit() {
    setState(() => _formFoiEnviado = true);
    if (_formKey.currentState!.validate() && _isFormValido()) {
      final partesData = _dataNascimento.text.split('/');
      final dataNascimento = DateTime(
        int.parse(partesData[2]),
        int.parse(partesData[1]),
        int.parse(partesData[0]),
      );

      widget.onSubmit(
        Usuario(
          id: widget.usuario?.id,
          nome: _nome.text,
          cpf: _cpf.text.replaceAll(RegExp(r'[^0-9]'), ''),
          dataNascimento: dataNascimento,
          distrito: _selectedDistritoNome ?? '',
          igrejaId: _selectedIgrejaId ?? '',
          nomeIgreja: _selectedIgrejaNome ?? '',
          sexo: _sexo ?? '',
          telefone: int.parse(telefoneFormatter.getUnmaskedText()),
          tipoUsuario: 'Professor',
          ativo: 'S',
        ),
      );
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
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nome,
            decoration: const InputDecoration(labelText: 'Nome'),
            validator: (value) {
              if (!_formFoiEnviado) return null;
              if (value == null || value.isEmpty) return 'Informe o nome';
              return null;
            },
          ),
          CampoCpfWidget(
            controller: _cpf,
            onCpfCheck:
                (duplicado) => setState(() => _cpfDuplicado = duplicado),
          ),
          CampoDataNascimentoWidget(
            controller: _dataNascimento,
            showErrors: _formFoiEnviado,
          ),
          CampoTelefoneWidget(
            controller: _telefone,
            showErrors: _formFoiEnviado,
          ),
          CampoSexoWidget(
            selectedSexo: _sexo,
            onChanged: (value) => setState(() => _sexo = value),
            showErrors: _formFoiEnviado,
          ),
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
                _fetchIgrejas(value!);
              });
            },
            showErrors: _formFoiEnviado,
          ),
          DropdownIgrejaWidget(
            selectedId: _selectedIgrejaId,
            igrejas: _igrejas,
            onChanged: (value) {
              final nome = _igrejas.firstWhere((i) => i['id'] == value)['nome'];
              setState(() {
                _selectedIgrejaId = value;
                _selectedIgrejaNome = nome;
              });
            },
            showErrors: _formFoiEnviado,
          ),
          const SizedBox(height: 20),
          HoverButtonWidget(
            label: 'Cadastrar',
            backgroundColor: const Color(0xFF0B1121),
            hoverColor: const Color(0xFF1F2A3F),
            textColor: Colors.white,
            onPressed: _isFormValido() ? _submit : () {},
          ),
        ],
      ),
    );
  }
}




/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/usuario_model.dart';
import 'utils/validators.dart';
import 'utils/masks.dart';
import 'widgets/campo_cpf_widget.dart';
import 'widgets/campo_telefone_widget.dart';
import 'widgets/dropdown_distrito_widget.dart';
import 'widgets/dropdown_igreja_widget.dart';
import 'widgets/campo_data_nascimento_widget.dart';
import 'widgets/campo_sexo_widget.dart';

class UsuarioFormWidget extends StatefulWidget {
  final Function(Usuario usuario) onSubmit;
  final Usuario? usuario;

  const UsuarioFormWidget({super.key, required this.onSubmit, this.usuario});

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

  bool _cpfDuplicado = false;
  bool _formFoiEnviado = false;

  @override
  void initState() {
    final u = widget.usuario;
    _nome = TextEditingController(text: u?.nome);
    _cpf = TextEditingController(text: u?.cpf);
    _dataNascimento = TextEditingController(
      text:
          u != null
              ? "${u.dataNascimento.day.toString().padLeft(2, '0')}/"
                  "${u.dataNascimento.month.toString().padLeft(2, '0')}/"
                  "${u.dataNascimento.year}"
              : '',
    );
    _telefone = TextEditingController(text: u?.telefone.toString());
    _sexo = u?.sexo;

    _fetchDistritos();
    if (u != null) {
      _selectedDistritoNome = u.distrito;
      _selectedIgrejaId = u.igrejaId;
      _selectedIgrejaNome = u.nomeIgreja;
      _selectedDistritoId = null; // deixamos null para não quebrar seleção
    }
    super.initState();
  }

  Future<void> _fetchDistritos() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('distritos').get();
    setState(() {
      _distritos =
          snapshot.docs
              .map((doc) => {'id': doc.id, 'nome': doc['nome']})
              .toList();
    });
  }

  Future<void> _fetchIgrejas(String distritoId) async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('igrejas')
            .where('distritoId', isEqualTo: distritoId)
            .get();
    setState(() {
      _igrejas =
          snapshot.docs
              .map((doc) => {'id': doc.id, 'nome': doc['nome']})
              .toList();
    });
  }

  void _submit() {
    setState(() => _formFoiEnviado = true);
    if (_formKey.currentState!.validate() && _isFormValido()) {
      final partesData = _dataNascimento.text.split('/');
      final dataNascimento = DateTime(
        int.parse(partesData[2]),
        int.parse(partesData[1]),
        int.parse(partesData[0]),
      );

      widget.onSubmit(
        Usuario(
          id: widget.usuario?.id,
          nome: _nome.text,
          cpf: _cpf.text.replaceAll(RegExp(r'[^0-9]'), ''),
          dataNascimento: dataNascimento,
          distrito: _selectedDistritoNome ?? '',
          igrejaId: _selectedIgrejaId ?? '',
          nomeIgreja: _selectedIgrejaNome ?? '',
          sexo: _sexo ?? '',
          telefone: int.parse(telefoneFormatter.getUnmaskedText()),
          tipoUsuario: 'Professor',
          ativo: 'S',
        ),
      );
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
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nome,
            decoration: const InputDecoration(labelText: 'Nome'),
            validator: (value) {
              if (!_formFoiEnviado) return null;
              if (value == null || value.isEmpty) return 'Informe o nome';
              return null;
            },
          ),
          CampoCpfWidget(
            controller: _cpf,
            onCpfCheck:
                (duplicado) => setState(() => _cpfDuplicado = duplicado),
          ),
          CampoDataNascimentoWidget(
            controller: _dataNascimento,
            showErrors: _formFoiEnviado,
          ),
          CampoTelefoneWidget(
            controller: _telefone,
            showErrors: _formFoiEnviado,
          ),
          CampoSexoWidget(
            selectedSexo: _sexo,
            onChanged: (value) => setState(() => _sexo = value),
            showErrors: _formFoiEnviado,
          ),
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
                _fetchIgrejas(value!);
              });
            },
            showErrors: _formFoiEnviado,
          ),
          DropdownIgrejaWidget(
            selectedId: _selectedIgrejaId,
            igrejas: _igrejas,
            onChanged: (value) {
              final nome = _igrejas.firstWhere((i) => i['id'] == value)['nome'];
              setState(() {
                _selectedIgrejaId = value;
                _selectedIgrejaNome = nome;
              });
            },
            showErrors: _formFoiEnviado,
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _submit, child: const Text('Cadastrar')),
        ],
      ),
    );
  }
}
*/