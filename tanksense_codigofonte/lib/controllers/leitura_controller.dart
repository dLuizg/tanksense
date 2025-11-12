// lib/controllers/leitura_controller.dart

// POO: Importando a classe 'Leitura', que é o "molde" (modelo) dos dados.
import '../models/leitura.dart';
// POO: Importando a classe 'LeituraService', que encapsula a lógica de negócio.
import '../services/leitura_service.dart';

// POO: Definição da classe 'LeituraController'.
// Ela atua como um "gerente" para operações de Leitura.
class LeituraController {
  // POO: Atributo privado e final que armazena uma instância do serviço.
  final LeituraService _leituraService;

  // POO: Construtor da classe.
  // Ele recebe a instância do serviço (Injeção de Dependência).
  LeituraController(this._leituraService);

  // POO: Definição de um método da classe.
  // LÓGICA: Método assíncrono ('async') que retorna um 'Future'.
  // O '?' indica que ele pode retornar um objeto 'Leitura' ou 'null'.
  Future<Leitura?> cadastrarLeitura(
      DateTime timestamp,
      double distanciaCm,
      double nivelCm,
      double porcentagem,
      String status,
      String unidade,
      int sensorId) async {
    // LÓGICA: Imprime uma mensagem no console para debug.
    print('Controller: Cadastrando leitura...');

    // LÓGICA: Bloco 'try/catch' para tratamento de exceções (erros).
    try {
      // POO: Cria uma nova instância (objeto) da classe 'Leitura'.
      // LÓGICA: O ID '0' é usado como um valor temporário (placeholder).
      final novaLeitura = Leitura(
          0, timestamp, distanciaCm, nivelCm, porcentagem, status, unidade);

      // POO: Chama um método ('enviarNovasParaBanco') no objeto '_leituraService'.
      // LÓGICA: 'await' pausa a execução aqui até que o serviço
      // (que é assíncrono) termine de salvar os dados.
      final int linhasAfetadas =
          await _leituraService.enviarNovasParaBanco([novaLeitura], sensorId);

      // LÓGICA: Estrutura condicional (if).
      // Verifica se o serviço reportou que alguma linha foi (linhasAfetadas > 0).
      if (linhasAfetadas > 0) {
        // LÓGICA: Retorna o objeto 'novaLeitura' que foi criado localmente.
        // (Nota: este objeto ainda tem o ID 0).
        return novaLeitura;
      }

      // LÓGICA: Se 'linhasAfetadas' for 0 (ou menor), a inserção falhou.
      // Retorna 'null' para sinalizar a falha.
      return null;
    } catch (e) {
      // LÓGICA: Bloco 'catch'. Executado se qualquer erro ocorrer no 'try'.
      print('❌ Erro no cadastro da leitura: $e');
      // LÓGICA: Retorna 'null' para sinalizar que uma exceção ocorreu.
      return null;
    }
  }
} // POO: Fim da definição da classe 'LeituraController'.
