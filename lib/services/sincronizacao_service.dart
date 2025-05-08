import '../../core/global.dart' as globals;
import 'sincronizacao/alunos_sincronizacao.dart';
import 'sincronizacao/usuarios_sincronizacao.dart';
import 'sincronizacao/matriculas_sincronizacao.dart';
import 'sincronizacao/ranking_sincronizacao.dart';

/* class SincronizacaoService {
  static Future<void> sincronizarTudo() async {
    print("🚀 Iniciando sincronização geral...");
    await UsuariosSincronizacao.sincronizarUsuariosLocaisPendentes();
    await AlunosSincronizacao.sincronizar(globals.cpfLogado ?? '');
    await MatriculasSincronizacao.sincronizar(globals.cpfLogado ?? '');
    
  }
} */

class SincronizacaoService {
  static Future<void> sincronizarTudo() async {
    print("🚀 Iniciando sincronização geral...");
    await UsuariosSincronizacao.sincronizarUsuariosLocaisPendentes();
    await AlunosSincronizacao.sincronizar(globals.cpfLogado ?? '');
    await MatriculasSincronizacao.sincronizar(globals.cpfLogado ?? '');
    await SincronizaRanking.sincronizar(globals.cpfLogado ?? '');
  }
}
