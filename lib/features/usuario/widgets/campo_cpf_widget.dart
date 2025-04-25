import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/masks.dart';
import '../utils/validators.dart';

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
  bool _cpfInvalido = false;

  @override
  void initState() {
    super.initState();
    _cpfFocus.addListener(() {
      if (!_cpfFocus.hasFocus) {
        final cpfLimpo = widget.controller.text.replaceAll(
          RegExp(r'[^0-9]'),
          '',
        );

        if (!validarCpf(cpfLimpo)) {
          setState(() {
            _cpfInvalido = true;
            _cpfDuplicado = false;
            widget.onCpfCheck(false);
          });
        } else {
          _cpfInvalido = false;
          _verificarCpfDuplicado(cpfLimpo);
        }

        // Revalida para exibir mensagens
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Form.of(context)?.validate();
        });
      }
    });
  }

  Future<void> _verificarCpfDuplicado(String cpfLimpo) async {
    final resultado =
        await FirebaseFirestore.instance
            .collection('usuarios')
            .where('cpf', isEqualTo: cpfLimpo)
            .get();

    setState(() {
      _cpfDuplicado = resultado.docs.isNotEmpty;
      widget.onCpfCheck(_cpfDuplicado);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: _cpfFocus,
      decoration: const InputDecoration(labelText: 'CPF'),
      inputFormatters: [cpfFormatter],
      keyboardType: TextInputType.number,
      validator: (value) {
        final cpfLimpo = value?.replaceAll(RegExp(r'[^0-9]'), '') ?? '';

        if (cpfLimpo.isEmpty || cpfLimpo.length != 11) {
          return 'CPF inválido';
        }

        if (_cpfInvalido) {
          return 'CPF inválido';
        }

        if (_cpfDuplicado) {
          return 'CPF já cadastrado';
        }

        return null;
      },
    );
  }
}
