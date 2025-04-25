import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/igreja.dart';
import '../widgets/custom_dropdown.dart';

class IgrejaFilterPage extends StatefulWidget {
  const IgrejaFilterPage({super.key});

  @override
  State<IgrejaFilterPage> createState() => _IgrejaFilterPageState();
}

class _IgrejaFilterPageState extends State<IgrejaFilterPage> {
  List<Igreja> igrejas = [];
  List<String> associacoes = [];
  String? selectedAssociacao;
  String? selectedDistrito;

  @override
  void initState() {
    super.initState();
    loadIgrejas();
  }

  Future<void> loadIgrejas() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('igrejas').get();
    final docs =
        snapshot.docs.map((e) => Igreja.fromMap(e.id, e.data())).toList();

    setState(() {
      igrejas = docs;
      associacoes = docs.map((e) => e.associacaoNome).toSet().toList()..sort();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> filteredDistritos =
        selectedAssociacao == null
            ? []
            : igrejas
                .where((e) => e.associacaoNome == selectedAssociacao)
                .map((e) => e.distritoNome)
                .toSet()
                .toList()
                .cast<String>();

    final List<String> filteredIgrejas =
        selectedDistrito == null
            ? []
            : igrejas
                .where((e) => e.distritoNome == selectedDistrito)
                .map((e) => e.nome)
                .toList()
                .cast<String>();

    return Scaffold(
      appBar: AppBar(title: const Text("Filtro de Igrejas")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              CustomDropdown<String>(
                label: "Associação",
                value: selectedAssociacao,
                items: associacoes,
                getLabel: (val) => val,
                onChanged: (val) {
                  setState(() {
                    selectedAssociacao = val;
                    selectedDistrito = null;
                  });
                },
              ),
              const SizedBox(height: 16),
              CustomDropdown<String>(
                label: "Distrito",
                value: selectedDistrito,
                items: filteredDistritos,
                getLabel: (val) => val,
                onChanged: (val) {
                  setState(() {
                    selectedDistrito = val;
                  });
                },
              ),
              const SizedBox(height: 16),
              if (filteredIgrejas.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredIgrejas.length,
                  itemBuilder: (context, index) {
                    final nome = filteredIgrejas[index];
                    return ListTile(title: Text(nome));
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
