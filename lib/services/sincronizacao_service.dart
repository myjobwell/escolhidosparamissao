import '../../core/global.dart' as globals;
import 'sincronizacao/alunos_sincronizacao.dart';
import 'sincronizacao/usuarios_sincronizacao.dart';
import 'sincronizacao/matriculas_sincronizacao.dart';
import 'sincronizacao/ranking_sincronizacao.dart';
import 'sincronizacao/licoes_sincronizacao.dart';

class SincronizacaoService {
  static Future<void> sincronizarTudo(String cpfProfessor) async {
    print("🚀 Iniciando sincronização geral com CPF: $cpfProfessor");
    await UsuariosSincronizacao.sincronizar(cpfProfessor); // <- aqui
    await AlunosSincronizacao.sincronizar(cpfProfessor);
    await MatriculasSincronizacao.sincronizar(cpfProfessor);
    await LicoesSincronizacao.sincronizar(cpfProfessor);
    await SincronizaRanking.sincronizar(cpfProfessor);
  }
}
