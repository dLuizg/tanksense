// lib/controllers/data_controller.dart

// POO: Importando as classes (modelos) que definem a estrutura dos dados.
import '../models/leitura.dart';
import '../models/producao.dart';

// POO: Importando as classes de Serviço (que encapsulam as regras de negócio).
import '../services/leitura_service.dart';
import '../services/producao_service.dart';

// POO: Importando o ServiceLocator (um Padrão de Projeto para Injeção de Dependência).
import '../models/service_locator.dart';

// POO: Definição da classe 'DataController'.
class DataController {
  // ... (injeção de dependência - sem mudanças) ...

  // POO: Declaração de atributos (campos) da classe.
  // Eles são inicializados buscando as instâncias de serviço no ServiceLocator.
  final LeituraService _leituraService = ServiceLocator().leituraService;
  final ProducaoService _producaoService = ServiceLocator().producaoService;

  // POO: Construtor padrão da classe.
  DataController();

  // POO: Definição de um método da classe.
  // LÓGICA: É um método assíncrono ('async') que não retorna valor ('void').
  Future<void> carregarESincronizarLeituras(
      String firebaseBaseUrl, int sensorId) async {
    // LÓGICA: Imprime uma mensagem no console para fins de debug.
    print(
        '🔄 Iniciando processo de sincronização de leituras para Sensor ID $sensorId...');

    // LÓGICA: Bloco 'try/catch' para tratamento de exceções (erros).
    try {
      // POO: Chama um método ('carregarDoFirebase') em outro objeto (_leituraService).
      // LÓGICA: 'await' pausa a execução até que a busca no Firebase termine.
      final List<Leitura> leituras = await _leituraService.carregarDoFirebase(
          firebaseBaseUrl, sensorId.toString());

      // LÓGICA: Estrutura condicional (if) para verificar se a lista está vazia.
      if (leituras.isEmpty) {
        print('📭 Nenhuma nova leitura para processar.');
        // LÓGICA: 'return' interrompe a execução do método (saída antecipada).
        return;
      }

      // NOTA: Esta linha abaixo AINDA VAI FALHAR até corrigirmos o LeituraService

      // POO: Chama um método ('enviarNovasParaBanco') no objeto '_leituraService'.
      // LÓGICA: 'await' pausa a execução até que o salvamento no banco termine.
      final int novasLeiturasSalvas =
          await _leituraService.enviarNovasParaBanco(leituras, sensorId);

      // LÓGICA: Imprime uma mensagem de sucesso no console.
      print(
          '🎉 Sincronização de Leituras concluída: $novasLeiturasSalvas novas leituras salvas.');
    } catch (e) {
      // LÓGICA: Bloco 'catch' que é executado se qualquer erro ocorrer no 'try'.
      print('❌ Falha crítica na sincronização de leituras: $e');
    }
  }

  // POO: Definição de um método da classe.
  // LÓGICA: Método assíncrono que retorna um 'Future'. O '?' indica que
  // o retorno pode ser um objeto 'Producao' ou pode ser 'null'.
  Future<Producao?> processarProducaoDiaria(int tanqueId) async {
    print('⚙️ Processando produção diária para Tanque ID $tanqueId...');

    // LÓGICA: Início do bloco 'try' para tratamento de erros.
    try {
      // POO: Chama o método 'gerarRegistroDiario' no objeto '_producaoService'.
      // LÓGICA: 'await' espera o serviço processar os dados e (talvez) retornar
      // uma instância de 'Producao'.
      final Producao? producao =
          await _producaoService.gerarRegistroDiario(tanqueId);

      // LÓGICA: Condicional (if/else) que verifica se o serviço retornou
      // um objeto ou retornou 'null'.
      if (producao != null) {
        // LÓGICA: Se 'producao' não é nulo, o bloco 'if' é executado.
        print(
            // CORREÇÃO:
            // POO: Acessando uma PROPRIEDADE ('tipoRegistro') do objeto 'producao'.
            '✅ Registro de Produção gerado com sucesso: ${producao.tipoRegistro}');

        // POO: Chama um método ('exibirDados') no objeto 'producao'.
        // O próprio objeto sabe como se "imprimir".
        producao.exibirDados();

        // LÓGICA: Retorna o objeto 'Producao' para quem chamou o método.
        return producao;
      } else {
        // LÓGICA: Se 'producao' é nulo, o bloco 'else' é executado.
        print(
            '📭 Nenhuma alteração de volume significativa para registrar produção.');

        // LÓGICA: Retorna 'null' para quem chamou o método.
        return null;
      }
    } catch (e) {
      // LÓGICA: Bloco 'catch' se o processamento falhar.
      print('❌ Falha no processamento da produção diária: $e');
      // LÓGICA: Retorna 'null' para indicar a falha.
      return null;
    }
  }
}
