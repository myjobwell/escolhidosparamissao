import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/usuario_model.dart';
import 'utils/validators.dart';
import 'widgets/campo_cpf_widget.dart';
import 'widgets/campo_telefone_widget.dart';
import 'widgets/dropdown_distrito_widget.dart';
import 'widgets/dropdown_igreja_widget.dart';
import 'widgets/campo_data_nascimento_widget.dart';

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

  bool _cpfDuplicado = false;

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
    _sexo = TextEditingController(text: u?.sexo);
    _telefone = TextEditingController(text: u?.telefone.toString());

    _fetchDistritos();
    if (u != null) {
      _selectedDistritoId = u.distrito;
      _selectedIgrejaId = u.igrejaId;
      _fetchIgrejas(u.distrito);
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
    if (_formKey.currentState!.validate()) {
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
        validarCpf(_cpf.text) &&
        _dataNascimento.text.length == 10 &&
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
          CampoCpfWidget(
            controller: _cpf,
            onCpfCheck:
                (duplicado) => setState(() => _cpfDuplicado = duplicado),
          ),
          CampoDataNascimentoWidget(controller: _dataNascimento),
          DropdownDistritoWidget(
            selectedId: _selectedDistritoId,
            distritos: _distritos,
            onChanged: (value) {
              setState(() {
                _selectedDistritoId = value;
                _selectedIgrejaId = null;
                _selectedIgrejaNome = null;
                _fetchIgrejas(value!);
              });
            },
          ),
          DropdownIgrejaWidget(
            selectedId: _selectedIgrejaId,
            igrejas: _igrejas,
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
          CampoTelefoneWidget(controller: _telefone),
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
