import 'package:flutter/material.dart';
import '../../widgets/forms_widgets/campo_telefone_widget.dart';
import '../../widgets/forms_widgets/campo_texto_widget.dart';
import '../../widgets/forms_widgets/campo_data_nascimento_widget.dart';
import '../../widgets/forms_widgets/campo_sexo_widget.dart';
import '../../widgets/button.dart';
import 'adicionar_aluno_controller.dart';

class AdicionarAlunoForm extends StatefulWidget {
  const AdicionarAlunoForm({super.key});

  @override
  State<AdicionarAlunoForm> createState() => _AdicionarAlunoFormState();
}

class _AdicionarAlunoFormState extends State<AdicionarAlunoForm> {
  final _formKey = GlobalKey<FormState>();
  final controller = AdicionarAlunoController();

  @override
  void initState() {
    super.initState();
    controller.init();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CampoTextoWidget(
            controller: controller.nome,
            label: 'Nome',
            validator: (value) {
              if (!controller.formFoiEnviado) return null;
              if (value == null || value.isEmpty) return 'Informe o nome';
              return null;
            },
          ),
          const SizedBox(height: 16),
          CampoDataNascimentoWidget(
            controller: controller.dataNascimento,
            showErrors: controller.formFoiEnviado,
          ),
          const SizedBox(height: 16),
          CampoTelefoneWidget(
            controller: controller.telefone,
            showErrors: controller.formFoiEnviado,
          ),
          CampoSexoWidget(
            selectedSexo: controller.sexo,
            onChanged: (value) => setState(() => controller.sexo = value),
            showErrors: controller.formFoiEnviado,
          ),
          const SizedBox(height: 20),
          Center(
            child: ButtonWidget(
              label: controller.isSaving ? 'Salvando...' : 'Cadastrar',
              backgroundColor: const Color(0xFF0B1121),
              hoverColor: const Color(0xFF1F2A3F),
              textColor: Colors.white,
              onPressed: () async {
                await controller.cadastrarUsuario(context, _formKey);
                if (mounted) setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }
}
