// lib/dao/usuario_dao.dart
import '../database_connection.dart';
import '../usuario.dart';

class UsuarioDao {
  final DatabaseConnection db;
  UsuarioDao(this.db);

  Future<List<Usuario>> fetchAll() async {
    final usuarios = <Usuario>[];
    try {
      // BÔNUS: É melhor usar row.fields['nome_coluna']
      // do que row.toList()[indice]. Veja a nota no final.
      var resultados = await db.connection!.query('SELECT * FROM usuario');
      for (var row in resultados) {
        var dados = row.toList();
        if (dados.length >= 3) {
          usuarios.add(Usuario(
            (dados[0] as num).toInt(),
            dados[1].toString(),
            dados.length > 2 ? dados[2].toString() : 'email@exemplo.com',
            dados.length > 3 ? dados[3].toString() : 'senha',
            dados.length > 4 ? dados[4].toString() : 'Usuario',
            DateTime.now(), // CUIDADO: Isso não está lendo a data do banco
            DateTime.now(), // CUIDADO: Isso não está lendo a data do banco
            dados.length > 7 ? (dados[7] as num).toInt() : 1,
          ));
        }
      }
    } catch (e) {
      print('❌ Erro ao carregar usuários: $e');
    }
    return usuarios;
  }

  // --- INÍCIO DA MODIFICAÇÃO ---

  /// Insere um usuário no banco e retorna o objeto salvo com o ID.
  Future<Usuario?> insert(Usuario usuario) async {
    try {
      // 1. Executamos a query e guardamos o resultado
      var resultado = await db.connection!.query(
        'INSERT INTO usuario (nome, email, senhaLogin, perfil, dataCriacao, ultimoLogin, empresa_idEmpresa) VALUES (?, ?, ?, ?, ?, ?, ?)',
        [
          usuario.nome,
          usuario.email,
          usuario.senhaLogin,
          usuario.perfil,
          usuario.dataCriacao.toIso8601String(),
          usuario.ultimoLogin.toIso8601String(),
          usuario.empresaId,
        ],
      );

      // 2. Verificamos se a inserção deu certo (gerou um ID)
      final int? newId = resultado.insertId;

      if (newId != null && newId > 0) {
        // 3. Retornamos um NOVO objeto Usuario com o ID correto.
        // (Seria ideal ter um método 'usuario.copyWith(id: newId)')
        return Usuario(
          newId,
          usuario.nome,
          usuario.email,
          usuario.senhaLogin,
          usuario.perfil,
          usuario.dataCriacao,
          usuario.ultimoLogin,
          usuario.empresaId,
        );
      }
      return null; // Falha na inserção
    } catch (e) {
      print('❌ Erro ao salvar usuário: $e');
      rethrow; // Propaga o erro para a camada de serviço
    }
  }
  // --- FIM DA MODIFICAÇÃO ---
}
