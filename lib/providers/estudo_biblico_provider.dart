import 'package:flutter/foundation.dart';
import '../models/estudos_biblicos_model.dart';
import '../databases/db_estudos.dart';

class EstudoBiblicoProvider with ChangeNotifier {
  List<EstudoBiblico> _estudos = [];

  List<EstudoBiblico> get estudos => _estudos;

  Future<void> carregarEstudos() async {
    _estudos = await DbEstudos.listarEstudos();
    notifyListeners();
  }

  Future<void> sincronizar() async {
    await DbEstudos.sincronizarEstudosComApi();
    await carregarEstudos();
  }
}
