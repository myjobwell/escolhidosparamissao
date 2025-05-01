// TODO Implement this library.
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuario_model.dart';

class FirebaseUsuarioService {
  static final _collection = FirebaseFirestore.instance.collection('usuarios');

  // Função para salvar o usuário no Firestore
  static Future<bool> salvarUsuario(Usuario usuario) async {
    try {
      await _collection.doc(usuario.id).set(usuario.toMap());
      return true; // sucesso
    } catch (e) {
      print('Erro ao salvar usuário no Firebase: $e');
      return false; // erro
    }
  }

  // (opcional) Buscar um usuário pelo CPF
  static Future<Usuario?> buscarUsuarioPorCpf(String cpf) async {
    try {
      final doc = await _collection.doc(cpf).get();
      if (doc.exists) {
        return Usuario.fromMap(doc.data()!, doc.id);
      } else {
        return null;
      }
    } catch (e) {
      print('Erro ao buscar usuário no Firebase: $e');
      return null;
    }
  }
}
