import 'package:flutter/foundation.dart';
import '../models/estudos_biblicos_model.dart';
import '../models/licoes_model.dart';
import '../models/conteudo_model.dart';
import '../databases/estudos_dao.dart';

class EstudoBiblicoProvider with ChangeNotifier {
  List<EstudoBiblico> _estudos = [];
  List<Licao> _licoes = [];
  List<Conteudo> _conteudos = [];

  List<EstudoBiblico> get estudos => _estudos;
  List<Licao> get licoes => _licoes;
  List<Conteudo> get conteudos => _conteudos;

  /// Carrega todos os estudos do banco
  Future<void> carregarEstudos() async {
    _estudos = await DbEstudos.listarEstudos();
    notifyListeners();
  }

  /// Carrega as lições associadas a um estudo específico
  Future<void> carregarLicoesPorEstudo(int idEstudo) async {
    _licoes = await DbEstudos.listarLicoesPorEstudo(idEstudo);
    notifyListeners();
  }

  /// Carrega os conteúdos de uma lição específica
  Future<void> carregarConteudosPorLicao(int idLicao) async {
    _conteudos = await DbEstudos.listarConteudosPorLicao(idLicao);
    notifyListeners();
  }

  /// Sincroniza estudos e lições da API
  Future<void> sincronizar() async {
    await DbEstudos.sincronizarEstudosComApi();
    await carregarEstudos();
  }
}
