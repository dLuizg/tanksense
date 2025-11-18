// lib/services/dispositivo_service.dart
import '../models/dispositivo.dart';
import '../models/database/database_connection.dart';
import '../dao/dispositivo_dao.dart';

class DispositivoService {
  final DispositivoDao _dao;

  // (Lembrete: Este construtor não é ideal para Injeção de Dependência)
  DispositivoService(DatabaseConnection db) : _dao = DispositivoDao(db);

  // ESTE é o construtor correto para usar com seu ServiceLocator
  DispositivoService.fromDao(this._dao);

  Future<List<Dispositivo>> listar() async {
    return await _dao.fetchAll();
  }

  // --- INÍCIO DA MODIFICAÇÃO ---

  /// Valida e cadastra um dispositivo, retornando o objeto salvo.
  Future<Dispositivo?> cadastrar(Dispositivo dispositivo) async {
    // 1. Lógica de Negócio (Validação) - Isso está PERFEITO.
    if (dispositivo.modelo.trim().isEmpty ||
        dispositivo.status.trim().isEmpty) {
      throw ArgumentError('Modelo e status são obrigatórios');
    }

    // 2. O _dao.insert agora retorna Future<Dispositivo?>,
    //    então nós simplesmente retornamos o resultado dele.
    return await _dao.insert(dispositivo);
  }

  /// Método 'criar' corrigido, mas o uso dele não é recomendado.
  Future<Dispositivo?> criar(String nome) async {
    final dispositivo = Dispositivo(0, nome, 'Ativo');

    // 3. Chamamos o 'cadastrar' (que agora retorna o objeto salvo)
    //    e retornamos esse objeto (com ID).
    final dispositivoSalvo = await cadastrar(dispositivo);
    return dispositivoSalvo;
  }
  // --- FIM DA MODIFICAÇÃO ---
}
