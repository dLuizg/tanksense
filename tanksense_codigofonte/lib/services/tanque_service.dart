// lib/services/tanque_service.dart
import '../models/tanque.dart';
import '../models/database_connection.dart';
import '../dao/tanque_dao.dart';

class TanqueService {
  final TanqueDao _dao;

  // (Lembrete: Este construtor não é ideal para Injeção de Dependência)
  TanqueService(DatabaseConnection db) : _dao = TanqueDao(db);

  // ESTE é o construtor correto para usar com seu ServiceLocator
  TanqueService.fromDao(this._dao);

  Future<List<Tanque>> listar() async {
    return await _dao.fetchAll();
  }

  // --- INÍCIO DA MODIFICAÇÃO ---

  /// Valida e cadastra um tanque, retornando o objeto salvo.
  Future<Tanque?> cadastrar(
      Tanque tanque, int localId, int dispositivoId) async {
    // 1. Lógica de Negócio (Validação) - Isso está PERFEITO.
    // O Service é o lugar certo para esta lógica.
    if (tanque.altura <= 0 || tanque.volumeMax <= 0) {
      throw ArgumentError('Altura e volume máximo devem ser positivos');
    }

    // 2. O _dao.insert agora retorna Future<Tanque?>,
    //    então nós simplesmente retornamos o resultado dele.
    return await _dao.insert(tanque, localId, dispositivoId);
  }

  /// Método 'criar' corrigido, mas o uso dele não é recomendado.
  /// (O Controller já faz isso melhor).
  Future<Tanque?> criar(String nome) async {
    final tanque =
        Tanque(0, 2.0, 1000.0, 0.0); // altura, volumeMax, volumeAtual

    // 3. Chamamos o 'cadastrar' (que agora retorna o objeto salvo)
    //    e retornamos esse objeto (com ID).
    final tanqueSalvo = await cadastrar(tanque, 1, 1); // placeholders
    return tanqueSalvo;
  }
  // --- FIM DA MODIFICAÇÃO ---
}
