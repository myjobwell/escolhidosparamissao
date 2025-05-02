import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/global.dart';
import '../models/usuario_model.dart';
import '../databases/db_usuario.dart';

class SincronizacaoService {
  /// Método principal chamado pela aplicação
  static Future<void> sincronizarUsuariosPendentes() async {
    await _sincronizarUsuariosLocaisPendentes();
    await sincronizarAlunosDoProfessor('');
  }

  /// 1. Sincroniza os usuários locais que ainda não estão no Firebase
  static Future<void> _sincronizarUsuariosLocaisPendentes() async {
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

  /// 2. Sincroniza os alunos do professor logado do Firebase para o banco local
  /*
  static Future<void> sincronizarAlunosDoProfessor(String cpfProfessor) async {
    try {
      print('🔍 Buscando alunos com id_professor == $cpfProfessor');

      final snapshot =
          await FirebaseFirestore.instance
              .collection('usuarios')
              .where('id_professor', isEqualTo: cpfProfessor)
              .get();

      print('📦 ${snapshot.docs.length} alunos encontrados no Firebase.');

      final tarefas =
          snapshot.docs.map((doc) async {
            final data = doc.data();
            final String cpfAluno = doc.id;

            final Usuario? alunoLocal = await DbUsuario.buscarUsuarioPorCpf(
              cpfAluno,
            );

            if (alunoLocal == null) {
              final novoAluno = Usuario(
                id: data['id'] ?? cpfAluno,
                nome: data['nome'] ?? '',
                cpf: cpfAluno,
                sexo: data['sexo'] ?? '',
                telefone: data['telefone'] ?? '',
                email: data['email'] ?? '',
                nascimento: data['nascimento'] ?? '',
                tipoUsuario: data['tipo_usuario'] ?? '',
                divisaoId: data['divisaoId'] ?? 0,
                divisaoNome: data['divisaoNome'] ?? '',
                uniaoId: data['uniaoId'] ?? 0,
                uniaoNome: data['uniaoNome'] ?? '',
                associacaoId: data['associacaoId'] ?? 0,
                associacaoNome: data['associacaoNome'] ?? '',
                distritoId: data['distritoId'] ?? 0,
                distritoNome: data['distritoNome'] ?? '',
                igrejaId: data['igrejaId'] ?? '',
                igrejaNome: data['igrejaNome'] ?? '',
                sincronizado: true,
                idProfessor: data['id_professor'],
              );

              await DbUsuario.salvarUsuario(novoAluno);
              print('✅ Aluno ${novoAluno.nome} salvo localmente.');
            }
          }).toList();

      await Future.wait(tarefas);
      print('✅ Sincronização de alunos concluída.');
    } catch (e) {
      print('❌ Erro ao sincronizar alunos do professor: $e');
    }
  }
  */
  static Future<void> sincronizarAlunosDoProfessor(String cpfProfessor) async {
    try {
      print('🔍 Buscando alunos com id_professor == $cpfProfessor');

      final snapshot =
          await FirebaseFirestore.instance
              .collection('usuarios')
              .where('id_professor', isEqualTo: cpfProfessor)
              .get();

      print('📦 ${snapshot.docs.length} alunos encontrados no Firebase.');

      final tarefas =
          snapshot.docs.map((doc) async {
            final data = doc.data();

            final String idDocumento = doc.id;
            final String? cpfFirebase = data['cpf'];

            if (cpfFirebase != null) {
              final Usuario? alunoLocal = await DbUsuario.buscarUsuarioPorCpf(
                cpfFirebase,
              );

              if (alunoLocal == null) {
                final novoAluno = Usuario(
                  id: data['id'] ?? idDocumento,
                  nome: data['nome'] ?? '',
                  cpf: cpfFirebase,
                  sexo: data['sexo'] ?? '',
                  telefone: data['telefone'] ?? '',
                  email: data['email'] ?? '',
                  nascimento: data['nascimento'] ?? '',
                  tipoUsuario: data['tipo_usuario'] ?? '',
                  divisaoId: data['divisaoId'] ?? 0,
                  divisaoNome: data['divisaoNome'] ?? '',
                  uniaoId: data['uniaoId'] ?? 0,
                  uniaoNome: data['uniaoNome'] ?? '',
                  associacaoId: data['associacaoId'] ?? 0,
                  associacaoNome: data['associacaoNome'] ?? '',
                  distritoId: data['distritoId'] ?? 0,
                  distritoNome: data['distritoNome'] ?? '',
                  igrejaId: data['igrejaId'] ?? '',
                  igrejaNome: data['igrejaNome'] ?? '',
                  sincronizado: true,
                  idProfessor: data['id_professor'],
                );

                await DbUsuario.salvarUsuario(novoAluno);
                print('✅ Aluno ${novoAluno.nome} salvo localmente.');
              } else {
                print('ℹ️ Aluno ${alunoLocal.nome} já existe localmente.');
              }
            } else {
              print('⚠️ Documento "$idDocumento" ignorado: CPF ausente.');
            }
          }).toList();

      await Future.wait(tarefas);
      print('✅ Sincronização de alunos concluída.');
    } catch (e) {
      print('❌ Erro ao sincronizar alunos do professor: $e');
    }
  }
}
