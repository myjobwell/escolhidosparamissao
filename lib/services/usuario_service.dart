import 'package:mipsmais/databases/app_database.dart';
import 'package:sqflite/sqflite.dart';
import '../models/usuario_model.dart';

class UsuarioService {
  // Listar usuários
  Future<List<Usuario>> listarUsuarios() async {
    final db = await AppDatabase.getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('usuarios');

    return List.generate(maps.length, (i) {
      return Usuario.fromMap(maps[i], maps[i]['id']);
    });
  }

  // Criar novo usuário
  Future<void> criarUsuario(Usuario usuario) async {
    final db = await AppDatabase.getDatabase();
    await db.insert(
      'usuarios',
      usuario.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Deletar usuário
  Future<void> deletarUsuario(String id) async {
    final db = await AppDatabase.getDatabase();
    await db.delete('usuarios', where: 'id = ?', whereArgs: [id]);
  }

  // Atualizar usuário
  Future<void> atualizarUsuario(Usuario usuario) async {
    final db = await AppDatabase.getDatabase();
    if (usuario.id != null) {
      await db.update(
        'usuarios',
        usuario.toMap(),
        where: 'id = ?',
        whereArgs: [usuario.id],
      );
    }
  }
}


/* import 'package:cloud_firestore/cloud_firestore.dart';
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
 */