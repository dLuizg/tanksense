// lib/controllers/leitura_controller.dart
import '../models/leitura.dart';
import '../services/leitura_service.dart';
import 'dart:async'; // Necessário para DateTime

//comentei mais um pouco
class LeituraController {
  final LeituraService _leituraService;

  LeituraController(this._leituraService);

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

      // CORREÇÃO: Chamamos o service (que retorna void/int)
      // Assumindo que 0 ou >0 significa sucesso/falha
      final int linhasAfetadas =
          await _leituraService.enviarNovasParaBanco([novaLeitura], sensorId);

      if (linhasAfetadas >= 0) {
        // Ou > 0, dependendo da sua lógica
        // Retornamos o objeto local (com ID 0)
        return novaLeitura;
      } else {
        return null; // A inserção falhou
      }
    } catch (e) {
      print('❌ Erro no cadastro da leitura: $e');
      return null;
    }
  }
}
