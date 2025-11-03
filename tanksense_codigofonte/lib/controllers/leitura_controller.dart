// lib/controllers/leitura_controller.dart
import '../leitura.dart';
import '../services/leitura_service.dart';

class LeituraController {
  final LeituraService _leituraService;

  LeituraController(this._leituraService);

  /// Cadastra uma nova Leitura de um Sensor
  Future<Leitura?> cadastrarLeitura(
      DateTime timestamp,
      double distanciaCm,
      double nivelCm,
      double porcentagem,
      String status,
      String unidade,
      int sensorId) async {
    print('Controller: Cadastrando leitura...');
    try {
      final novaLeitura = Leitura(
          0, timestamp, distanciaCm, nivelCm, porcentagem, status, unidade);

      // --- Início da Correção ---

      // 1. O service retorna um 'int' (provavelmente o número de linhas afetadas)
      final int linhasAfetadas =
          await _leituraService.enviarNovasParaBanco([novaLeitura], sensorId);

      // 2. Verificamos se a inserção foi bem-sucedida
      if (linhasAfetadas > 0) {
        // AVISO: Estamos retornando o objeto local com ID 0,
        // pois o service não nos retornou o objeto salvo.
        return novaLeitura;
      }

      // Se linhasAfetadas for 0, a inserção falhou.
      return null;

      // --- Fim da Correção ---
    } catch (e) {
      print('❌ Erro no cadastro da leitura: $e');
      return null;
    }
  }
}
