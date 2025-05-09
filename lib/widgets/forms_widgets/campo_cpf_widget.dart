import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../utils/masks.dart';
import '../../utils/validators.dart';

class CampoCpfWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(bool isDuplicated) onCpfCheck;

  const CampoCpfWidget({
    super.key,
    required this.controller,
    required this.onCpfCheck,
  });

  @override
  State<CampoCpfWidget> createState() => _CampoCpfWidgetState();
}

class _CampoCpfWidgetState extends State<CampoCpfWidget> {
  final FocusNode _cpfFocus = FocusNode();
  bool _cpfDuplicado = false;
  bool _campoInteragido = false;

  @override
  void initState() {
    super.initState();

    _cpfFocus.addListener(() {
      if (!_cpfFocus.hasFocus && widget.controller.text.isNotEmpty) {
        _campoInteragido = true;
        final cpf = _limparCpf(widget.controller.text);

        if (validarCpf(cpf)) {
          _verificarCpfDuplicado(cpf);
        } else {
          setState(() {
            _cpfDuplicado = false;
            widget.onCpfCheck(false);
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Form.of(context).validate();
          });
        }
      }
    });
  }

  Future<void> _verificarCpfDuplicado(String cpf) async {
    final resultado =
        await FirebaseFirestore.instance
            .collection('usuarios')
            .where('cpf', isEqualTo: cpf)
            .get();

    setState(() {
      _cpfDuplicado = resultado.docs.isNotEmpty;
      widget.onCpfCheck(_cpfDuplicado);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Form.of(context).validate();
    });
  }

  String _limparCpf(String input) => input.replaceAll(RegExp(r'[^0-9]'), '');

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: _cpfFocus,
      decoration: InputDecoration(
        labelText: 'CPF',
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFDADCE0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF0B1121), width: 1.5),
        ),
      ),
      inputFormatters: [cpfFormatter],
      keyboardType: TextInputType.number,
      onChanged: (_) {
        if (!_campoInteragido) {
          setState(() => _campoInteragido = true);
        }
      },
      validator: (value) {
        final cpf = _limparCpf(value ?? '');

        if (!_campoInteragido && cpf.isEmpty) return null;
        if (cpf.length != 11 || !validarCpf(cpf)) return 'CPF inválido';
        if (_cpfDuplicado) return 'CPF já cadastrado';

        return null;
      },
    );
  }
}
