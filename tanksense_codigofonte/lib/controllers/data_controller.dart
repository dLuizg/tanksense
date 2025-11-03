// lib/controllers/data_controller.dart

import '../leitura.dart';
import '../producao.dart';
import '../services/leitura_service.dart';
import '../services/producao_service.dart';
import '../service_locator.dart';

class DataController {
  // ... (injeção de dependência - sem mudanças) ...
  final LeituraService _leituraService = ServiceLocator().leituraService;
  final ProducaoService _producaoService = ServiceLocator().producaoService;

  DataController();

  // ... (carregarESincronizarLeituras - sem mudanças) ...
  Future<void> carregarESincronizarLeituras(
      String firebaseBaseUrl, int sensorId) async {
    print(
        '🔄 Iniciando processo de sincronização de leituras para Sensor ID $sensorId...');
    try {
      final List<Leitura> leituras = await _leituraService.carregarDoFirebase(
          firebaseBaseUrl, sensorId.toString());

      if (leituras.isEmpty) {
        print('📭 Nenhuma nova leitura para processar.');
        return;
      }

      // NOTA: Esta linha abaixo AINDA VAI FALHAR até corrigirmos o LeituraService
      final int novasLeiturasSalvas =
          await _leituraService.enviarNovasParaBanco(leituras, sensorId);

      print(
          '🎉 Sincronização de Leituras concluída: $novasLeiturasSalvas novas leituras salvas.');
    } catch (e) {
      print('❌ Falha crítica na sincronização de leituras: $e');
    }
  }

  // --- INÍCIO DA MODIFICAÇÃO (LINHA 64) ---
  Future<Producao?> processarProducaoDiaria(int tanqueId) async {
    print('⚙️ Processando produção diária para Tanque ID $tanqueId...');
    try {
      final Producao? producao =
          await _producaoService.gerarRegistroDiario(tanqueId);

      if (producao != null) {
        print(
            // CORREÇÃO: Trocamos o MÉTODO (obterTipo()) pela PROPRIEDADE (tipoRegistro)
            '✅ Registro de Produção gerado com sucesso: ${producao.tipoRegistro}');
        producao.exibirDados();
        return producao;
      } else {
        print(
            '📭 Nenhuma alteração de volume significativa para registrar produção.');
        return null;
      }
    } catch (e) {
      print('❌ Falha no processamento da produção diária: $e');
      return null;
    }
  }
  // --- FIM DA MODIFICAÇÃO ---
}
