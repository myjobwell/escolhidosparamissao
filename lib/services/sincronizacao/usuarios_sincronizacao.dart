import 'package:cloud_firestore/cloud_firestore.dart';
import '../../databases/usuario_dao.dart';
import '../../models/usuario_model.dart';

class UsuariosSincronizacao {
  static Future<void> sincronizarUsuariosLocaisPendentes() async {
    print("📤 Iniciando sincronização de usuários locais pendentes...");
    final usuariosPendentes = await DbUsuario.getUsuariosNaoSincronizados();
    print(
      '📦 ${usuariosPendentes.length} usuários pendentes encontrados localmente.',
    );

    for (final usuario in usuariosPendentes) {
      try {
        final docRef = FirebaseFirestore.instance
            .collection('usuarios')
            .doc(usuario.id);
        final doc = await docRef.get();

        if (doc.exists) {
          final data = doc.data();
          final firebaseSincronizado = data?['sincronizado'];

          if (firebaseSincronizado == 0 || firebaseSincronizado == null) {
            await docRef.update({'sincronizado': 1});
            print(
              '🔁 Atualizado "sincronizado" no Firebase para ${usuario.nome}',
            );
          } else {
            print('✅ Usuário ${usuario.nome} já sincronizado no Firebase.');
          }
        } else {
          final usuarioMap = usuario.toMap();
          usuarioMap['sincronizado'] = 1;
          await docRef.set(usuarioMap);
          print('🆕 Usuário ${usuario.nome} inserido no Firebase.');
        }

        await DbUsuario.atualizarSincronizacao(usuario.id);
      } catch (e) {
        print('❌ Erro ao sincronizar ${usuario.nome}: $e');
      }
    }
  }
}
