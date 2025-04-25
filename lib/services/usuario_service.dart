import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuario_model.dart';

class UsuarioService {
  final _usuarios = FirebaseFirestore.instance.collection('usuarios');

  Stream<List<Usuario>> listarUsuarios() {
    return _usuarios.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Usuario.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Future<void> criarUsuario(Usuario usuario) async {
    await _usuarios.add(usuario.toMap());
  }

  Future<void> deletarUsuario(String id) async {
    await _usuarios.doc(id).delete();
  }

  Future<void> atualizarUsuario(Usuario usuario) async {
    if (usuario.id != null) {
      await _usuarios.doc(usuario.id).update(usuario.toMap());
    }
  }
}
