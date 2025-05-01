import 'package:flutter/foundation.dart';
import '../models/estudos_biblicos_model.dart';
import '../models/licoes_model.dart';
import '../databases/db_estudos.dart';

class EstudoBiblicoProvider with ChangeNotifier {
  List<EstudoBiblico> _estudos = [];
  List<Licao> _licoes = [];

  List<EstudoBiblico> get estudos => _estudos;
  List<Licao> get licoes => _licoes;

  /// Carrega todos os estudos do banco
  Future<void> carregarEstudos() async {
    _estudos = await DbEstudos.listarEstudos();
    notifyListeners();
  }

  /// Carrega as lições associadas a um estudo específico
  Future<void> carregarLicoesPorEstudo(int estudoId) async {
    _licoes = await DbEstudos.listarLicoesPorEstudo(estudoId);
    notifyListeners();
  }

  /// Sincroniza estudos e lições da API
  Future<void> sincronizar() async {
    await DbEstudos.sincronizarEstudosComApi();
    await carregarEstudos();
  }
}


/* import 'package:flutter/foundation.dart';
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
 */