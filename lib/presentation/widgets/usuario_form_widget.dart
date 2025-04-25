import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/usuario_model.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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
  late TextEditingController _sexo;
  late TextEditingController _telefone;

  String? _selectedDistritoId;
  String? _selectedIgrejaId;
  String? _selectedIgrejaNome;

  List<Map<String, dynamic>> _distritos = [];
  List<Map<String, dynamic>> _igrejas = [];

  final cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final FocusNode _cpfFocus = FocusNode();
  bool _cpfDuplicado = false;
  String? _cpfErroMensagem;

  @override
  void initState() {
    final u = widget.usuario;
    _nome = TextEditingController(text: u?.nome);
    _cpf = TextEditingController(text: u?.cpf);
    _dataNascimento = TextEditingController(
      text:
          u != null ? u.dataNascimento.toIso8601String().split("T").first : '',
    );
    _sexo = TextEditingController(text: u?.sexo);
    _telefone = TextEditingController(text: u?.telefone.toString());

    _cpfFocus.addListener(() {
      if (!_cpfFocus.hasFocus) {
        _verificarCpfDuplicado(_cpf.text);
      }
    });

    _fetchDistritos();
    if (u != null) {
      _selectedDistritoId = u.distrito;
      _selectedIgrejaId = u.igrejaId;
      _fetchIgrejas(u.distrito);
    }
    super.initState();
  }

  Future<void> _verificarCpfDuplicado(String cpf) async {
    final cpfLimpo = cpf.replaceAll(RegExp(r'[^0-9]'), '');

    final resultado =
        await FirebaseFirestore.instance
            .collection('usuarios')
            .where('cpf', isEqualTo: cpfLimpo)
            .get();

    setState(() {
      _cpfDuplicado = resultado.docs.isNotEmpty;
      _cpfErroMensagem = _cpfDuplicado ? 'CPF já cadastrado' : null;
    });

    _formKey.currentState?.validate();
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
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        Usuario(
          id: widget.usuario?.id,
          nome: _nome.text,
          cpf: _cpf.text.replaceAll(RegExp(r'[^0-9]'), ''),
          dataNascimento: DateTime.parse(_dataNascimento.text),
          distrito: _selectedDistritoId ?? '',
          igrejaId: _selectedIgrejaId ?? '',
          nomeIgreja: _selectedIgrejaNome ?? '',
          sexo: _sexo.text,
          telefone: int.parse(_telefone.text),
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
        _dataNascimento.text.isNotEmpty &&
        _selectedDistritoId != null &&
        _selectedIgrejaId != null &&
        _sexo.text.isNotEmpty &&
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
          ),
          TextFormField(
            controller: _cpf,
            focusNode: _cpfFocus,
            decoration: const InputDecoration(labelText: 'CPF'),
            inputFormatters: [cpfFormatter],
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty || value.length != 14) {
                return 'CPF inválido';
              }
              if (_cpfErroMensagem != null) {
                return _cpfErroMensagem;
              }
              return null;
            },
          ),
          TextFormField(
            controller: _dataNascimento,
            decoration: const InputDecoration(
              labelText: 'Data de Nascimento yyyy-MM-dd',
            ),
          ),
          DropdownButtonFormField<String>(
            value: _selectedDistritoId,
            decoration: const InputDecoration(labelText: 'Distrito'),
            items:
                _distritos.map((distrito) {
                  return DropdownMenuItem<String>(
                    value: distrito['id'],
                    child: Text(distrito['nome']),
                  );
                }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedDistritoId = value;
                _selectedIgrejaId = null;
                _selectedIgrejaNome = null;
                _fetchIgrejas(value!);
              });
            },
          ),
          DropdownButtonFormField<String>(
            value: _selectedIgrejaId,
            decoration: const InputDecoration(labelText: 'Igreja'),
            items:
                _igrejas.map((igreja) {
                  return DropdownMenuItem<String>(
                    value: igreja['id'],
                    child: Text(igreja['nome']),
                  );
                }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedIgrejaId = value;
                _selectedIgrejaNome =
                    _igrejas.firstWhere((i) => i['id'] == value)['nome'];
              });
            },
          ),
          TextFormField(
            controller: _sexo,
            decoration: const InputDecoration(labelText: 'Sexo'),
          ),
          TextFormField(
            controller: _telefone,
            decoration: const InputDecoration(labelText: 'Telefone'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isFormValido() ? _submit : null,
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
