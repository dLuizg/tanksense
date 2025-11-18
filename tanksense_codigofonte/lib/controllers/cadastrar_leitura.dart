// lib/controllers/casdastrar_leitura.dart

// POO: Importando a classe 'Leitura', que define o modelo de dados (um objeto).
import '../models/leitura.dart';
// POO: Importando a classe 'LeituraService', que encapsula a regra de negócio.
import '../services/leitura_service.dart';
// LÓGICA: Importando a biblioteca para lidar com programação assíncrona (Futures).
import 'dart:async';

// POO: Definição da classe 'LeituraController'. Classes são o pilar da POO.
class LeituraController {
  // POO: Declaração de um atributo (ou campo) final.
  // Este atributo guarda uma instância de outra classe (LeituraService).
  final LeituraService _leituraService;

  // POO: Este é o Construtor da classe.
  // Ele usa o padrão de Injeção de Dependência para receber o serviço.
  LeituraController(this._leituraService);

  // POO: Definição de um método da classe.
  // LÓGICA: O método é 'async' e retorna um 'Future', indicando
  // que ele executa uma operação que leva tempo (assíncrona).
  Future<Leitura?> cadastrarLeitura(
      DateTime timestamp,
      double distanciaCm,
      double nivelCm,
      double porcentagem,
      String status,
      String unidade,
      int sensorId) async {
    // LÓGICA: Um comando simples para imprimir texto no console (debug).
    print('Controller: Cadastrando leitura...');

    // LÓGICA: Bloco 'try/catch' para tratamento de exceções (erros).
    try {
      // POO: Instanciação de um objeto. Estamos criando uma nova 'Leitura'
      // usando a classe 'Leitura' (o "molde") e passando os dados.
      final novaLeitura = Leitura(
          0, timestamp, distanciaCm, nivelCm, porcentagem, status, unidade);

      // POO: Chamada de um método ('enviarNovasParaBanco') em outro objeto (_leituraService).
      // Isso é a "troca de mensagens" entre objetos.
      // LÓGICA: O 'await' pausa a execução deste método até que o serviço responda.
      final int linhasAfetadas =
          await _leituraService.enviarNovasParaBanco([novaLeitura], sensorId);

      // LÓGICA: Uma estrutura condicional (if/else) para tomar decisões
      // com base no resultado (linhasAfetadas) vindo do serviço.
      if (linhasAfetadas >= 0) {
        // LÓGICA: Comando de retorno (return) se a condição for verdadeira.
        return novaLeitura;
      } else {
        // LÓGICA: Comando de retorno (return) se a condição for falsa.
        return null;
      }
    } catch (e) {
      // LÓGICA: Captura um erro (exceção) se algo no 'try' falhar.
      // LÓGICA: Imprime a mensagem de erro no console.
      print('❌ Erro no cadastro da leitura: $e');
      // LÓGICA: Retorna nulo para indicar que o cadastro falhou.
      return null;
    }
  }
}
