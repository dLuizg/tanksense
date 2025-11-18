// lib/services/usuario_service.dart
import '../models/usuario.dart';
import '../models/database/database_connection.dart';
import '../dao/usuario_dao.dart';

class UsuarioService {
  final UsuarioDao _dao;

  // CUIDADO: Este construtor viola a Injeção de Dependência (DI).
  // O Service não deve criar seu próprio DAO.
  UsuarioService(DatabaseConnection db) : _dao = UsuarioDao(db);

  // ESTE é o construtor correto para usar com seu ServiceLocator!
  UsuarioService.fromDao(this._dao);

  Future<List<Usuario>> listar() async {
    return await _dao.fetchAll();
  }

  // --- INÍCIO DA MODIFICAÇÃO ---

  /// Valida e cadastra um usuário, retornando o objeto salvo.
  Future<Usuario?> cadastrar(Usuario usuario) async {
    // 1. Lógica de Negócio (Validação) - Isso está PERFEITO.
    // O Service é o lugar certo para esta lógica.
    if (usuario.nome.trim().isEmpty ||
        usuario.email.trim().isEmpty ||
        usuario.senhaLogin.trim().isEmpty) {
      throw ArgumentError('Nome, email e senha são obrigatórios');
    }

    // 2. O _dao.insert agora retorna Future<Usuario?>,
    //    então nós simplesmente retornamos o resultado dele.
    return await _dao.insert(usuario);
  }

  /// Método 'criar' corrigido, mas o uso dele não é recomendado.
  /// (O Controller já faz isso melhor).
  Future<Usuario?> criar(String nome) async {
    final usuario = Usuario(
      0,
      nome,
      'email@exemplo.com', // placeholder
      'senha123', // placeholder
      'Operador',
      DateTime.now(),
      DateTime.now(),
      1, // empresaId placeholder
    );

    // 3. Chamamos o 'cadastrar' (que agora retorna o objeto salvo)
    //    e retornamos esse objeto.
    final usuarioSalvo = await cadastrar(usuario);
    return usuarioSalvo;
  }
  // --- FIM DA MODIFICAÇÃO ---
}
