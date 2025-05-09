import 'package:cloud_firestore/cloud_firestore.dart';
import '../../databases/usuario_dao.dart';
import '../../models/usuario_model.dart';

class UsuariosSincronizacao {
  static Future<void> sincronizar(String cpfProfessor) async {
    final firestore = FirebaseFirestore.instance;
    final usuariosRef = firestore.collection('usuarios');

    print("🔄 Sincronizando usuários do Firebase ➜ Local...");
    final snapshot =
        await usuariosRef.where('id_professor', isEqualTo: cpfProfessor).get();

    final Set<String> firebaseIds = {};

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final String idDoc = doc.id;
      firebaseIds.add(idDoc);

      final usuarioLocal = await DbUsuario.buscarUsuarioPorId(idDoc);
      if (usuarioLocal == null) {
        final novoUsuario = Usuario.fromMap(data, idDoc);
        await DbUsuario.salvarUsuario(novoUsuario);
        print('⬇️ Inserido localmente: ${novoUsuario.nome}');
      } else {
        print('🔁 Já existe localmente: ${usuarioLocal.nome}');
      }
    }

    print("🔄 Sincronizando banco local ➜ Firebase...");
    final locais = await DbUsuario.getUsuariosNaoSincronizados();

    for (final usuario in locais) {
      final docRef = usuariosRef.doc(usuario.id);
      final doc = await docRef.get();

      if (!doc.exists) {
        final map = usuario.toMap();
        map['sincronizado'] = 1;
        await docRef.set(map);
        print('⬆️ Enviado ao Firebase: ${usuario.nome}');
      } else {
        print('🔁 Já existe no Firebase: ${usuario.nome}');
      }

      await DbUsuario.atualizarSincronizacao(usuario.id);
    }

    print('✅ Sincronização completa.');
  }
}


/* import 'package:cloud_firestore/cloud_firestore.dart';
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
 */