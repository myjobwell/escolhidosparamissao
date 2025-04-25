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
  String? _selectedDistritoNome;
  String? _selectedIgrejaId;
  String? _selectedIgrejaNome;

  List<Map<String, dynamic>> _distritos = [];
  List<Map<String, dynamic>> _igrejas = [];

  final cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

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
      widget.onSubmit(
        Usuario(
          id: widget.usuario?.id,
          nome: _nome.text,
          cpf: _cpf.text,
          dataNascimento: DateTime.parse(_dataNascimento.text),
          distrito: _selectedDistritoId ?? '',
          igrejaId: _selectedIgrejaId ?? '',
          nomeIgreja: _selectedIgrejaNome ?? '',
          sexo: _sexo.text,
          telefone: int.parse(_telefone.text),
          tipoUsuario: 'Professor', // Valor fixo
          ativo: 'S', // Valor fixo
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nome,
            decoration: InputDecoration(labelText: 'Nome'),
          ),
          TextFormField(
            controller: _cpf,
            decoration: const InputDecoration(labelText: 'CPF'),
            inputFormatters: [cpfFormatter],
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty || value.length != 14) {
                return 'CPF inválido';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _dataNascimento,
            decoration: InputDecoration(
              labelText: 'Data de Nascimento yyyy-MM-dd',
            ),
          ),
          DropdownButtonFormField<String>(
            value: _selectedDistritoId,
            decoration: InputDecoration(labelText: 'Distrito'),
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
            decoration: InputDecoration(labelText: 'Igreja'),
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
            decoration: InputDecoration(labelText: 'Sexo'),
          ),
          TextFormField(
            controller: _telefone,
            decoration: InputDecoration(labelText: 'Telefone'),
          ),
          ElevatedButton(onPressed: _submit, child: Text('Salvar')),
        ],
      ),
    );
  }
}
