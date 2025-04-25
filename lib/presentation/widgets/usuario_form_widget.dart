import 'package:flutter/material.dart';
import '../../models/usuario_model.dart';

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
  late TextEditingController _distrito;
  late TextEditingController _igrejaId;
  late TextEditingController _nomeIgreja;
  late TextEditingController _sexo;
  late TextEditingController _telefone;
  late TextEditingController _tipoUsuario;
  late TextEditingController _ativo;

  @override
  void initState() {
    final u = widget.usuario;
    _nome = TextEditingController(text: u?.nome);
    _cpf = TextEditingController(text: u?.cpf);
    _dataNascimento = TextEditingController(
      text:
          u != null ? u.dataNascimento.toIso8601String().split("T").first : '',
    );
    _distrito = TextEditingController(text: u?.distrito);
    _igrejaId = TextEditingController(text: u?.igrejaId);
    _nomeIgreja = TextEditingController(text: u?.nomeIgreja);
    _sexo = TextEditingController(text: u?.sexo);
    _telefone = TextEditingController(text: u?.telefone.toString());
    _tipoUsuario = TextEditingController(text: u?.tipoUsuario);
    _ativo = TextEditingController(text: u?.ativo);
    super.initState();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        Usuario(
          id: widget.usuario?.id,
          nome: _nome.text,
          cpf: _cpf.text,
          dataNascimento: DateTime.parse(_dataNascimento.text),
          distrito: _distrito.text,
          igrejaId: _igrejaId.text,
          nomeIgreja: _nomeIgreja.text,
          sexo: _sexo.text,
          telefone: int.parse(_telefone.text),
          tipoUsuario: _tipoUsuario.text,
          ativo: _ativo.text,
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
            decoration: InputDecoration(labelText: 'CPF'),
          ),
          TextFormField(
            controller: _dataNascimento,
            decoration: InputDecoration(
              labelText: 'Data de Nascimento yyyy-MM-dd',
            ),
          ),
          TextFormField(
            controller: _distrito,
            decoration: InputDecoration(labelText: 'Distrito'),
          ),
          TextFormField(
            controller: _igrejaId,
            decoration: InputDecoration(labelText: 'Igreja ID'),
          ),
          TextFormField(
            controller: _nomeIgreja,
            decoration: InputDecoration(labelText: 'Nome Igreja'),
          ),
          TextFormField(
            controller: _sexo,
            decoration: InputDecoration(labelText: 'Sexo'),
          ),
          TextFormField(
            controller: _telefone,
            decoration: InputDecoration(labelText: 'Telefone'),
          ),
          TextFormField(
            controller: _tipoUsuario,
            decoration: InputDecoration(labelText: 'Tipo Usuário'),
          ),
          TextFormField(
            controller: _ativo,
            decoration: InputDecoration(labelText: 'Ativo'),
          ),
          ElevatedButton(onPressed: _submit, child: Text('Salvar')),
        ],
      ),
    );
  }
}
