import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../services/sincronizacao/usuarios_sincronizacao.dart';
import '../services/sincronizacao/matriculas_sincronizacao.dart';
import '../services/sincronizacao/licoes_sincronizacao.dart';
import '../services/sincronizacao/ranking_sincronizacao.dart'; // ⬅️ Import da sincronização de ranking
import '../core/global.dart';

class SincronizacaoAutoService {
  static StreamSubscription<ConnectivityResult>? _subscription;

  static void iniciar() {
    _subscription = Connectivity().onConnectivityChanged.listen((result) async {
      if (result != ConnectivityResult.none) {
        print('🔌 Conectado. Tentando sincronizar dados...');

        if (cpfLogado == null) {
          print('⚠️ CPF logado não definido. Sincronização abortada.');
          return;
        }

        try {
          await UsuariosSincronizacao.sincronizar(cpfLogado!);
          await MatriculasSincronizacao.sincronizar(cpfLogado!);
          await LicoesSincronizacao.sincronizar(cpfLogado!);
          await SincronizaRanking.sincronizar(
            cpfLogado!,
          ); // ✅ Sincroniza ranking

          print('✅ Sincronização automática concluída.');
        } catch (e) {
          print('❌ Erro na sincronização automática: $e');
        }
      }
    });
  }

  static void parar() {
    _subscription?.cancel();
  }
}
