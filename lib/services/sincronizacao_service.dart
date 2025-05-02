import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuario_model.dart';
import '../databases/db_usuario.dart';

class SincronizacaoService {
  static Future<void> sincronizarUsuariosPendentes() async {
    final usuariosPendentes = await DbUsuario.getUsuariosNaoSincronizados();

    for (final usuario in usuariosPendentes) {
      try {
        final docRef = FirebaseFirestore.instance
            .collection('usuarios')
            .doc(usuario.id);

        final doc = await docRef.get();

        if (doc.exists) {
          final data = doc.data();
          final firebaseSincronizado = data?['sincronizado'];

          // Se está no Firebase mas não está marcado como sincronizado
          if (firebaseSincronizado == 0 || firebaseSincronizado == null) {
            await docRef.update({'sincronizado': 1});
            print(
              '🔁 Atualizado "sincronizado" no Firebase para ${usuario.nome}',
            );
          } else {
            print('✅ Usuário ${usuario.nome} já sincronizado no Firebase.');
          }
        } else {
          // Se não existe no Firebase, inserir com sincronizado = 1
          final usuarioMap = usuario.toMap();
          usuarioMap['sincronizado'] = 1;

          await docRef.set(usuarioMap);
          print('🆕 Usuário ${usuario.nome} inserido no Firebase.');
        }

        // Atualiza o campo local como sincronizado
        await DbUsuario.atualizarSincronizacao(usuario.id);
      } catch (e) {
        print('❌ Erro ao sincronizar ${usuario.nome}: $e');
      }
    }
  }
}
