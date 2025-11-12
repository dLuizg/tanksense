// lib/controllers/producao_controller.dart

// POO: Importando as classes (modelos) que definem a estrutura dos dados.
import '../models/producao.dart';
import '../models/leitura.dart';
// POO: Importando a classe de Serviço (que encapsula as regras de negócio).
import '../services/producao_service.dart';

// POO: Definição da classe 'ProducaoController'.
// Ela gerencia a lógica de buscar e exibir dados de Produção.
class ProducaoController {
  // POO: Atributo (campo) privado e final que armazena a instância do serviço.
  final ProducaoService _producaoService;

  /// POO: Construtor com injeção de dependência.
  /// Ele recebe o serviço do qual depende.
  ProducaoController(this._producaoService);

  // -------------------------------------------------------------------
  // MÉTODOS DE BUSCA (Apenas delegam para o Serviço)
  // -------------------------------------------------------------------

  /// Busca todos os registros de produção.
  // POO: Definição de um método da classe.
  // LÓGICA: Método assíncrono ('async') que retorna uma 'Future<List<Producao>>'.
  Future<List<Producao>> carregarTodosRegistros() async {
    // POO: Delega a chamada para o método 'listarTodos' do objeto '_producaoService'.
    // LÓGICA: 'await' espera o serviço responder e 'return' envia o resultado.
    return await _producaoService.listarTodos();
  }

  /// Busca registros de produção filtrados por mês e ano.
  // POO: Definição de um método da classe.
  // LÓGICA: Método assíncrono que recebe 'mes' e 'ano' como parâmetros.
  Future<List<Producao>> carregarPorPeriodo(int mes, int ano) async {
    // LÓGICA: Cria um objeto DateTime para o primeiro dia do mês.
    final inicio = DateTime(ano, mes, 1);
    // LÓGICA: Cria um objeto DateTime para o último dia do mês
    // (usando o truque do "dia 0" do mês seguinte).
    final fim = DateTime(ano, mes + 1, 0);

    // POO: Delega a chamada para o método 'listarPorPeriodo' do serviço.
    // LÓGICA: Passa as datas 'inicio' e 'fim' calculadas como argumentos.
    return await _producaoService.listarPorPeriodo(inicio, fim);
  }

  /// Busca leituras associadas a um tanque.
  // POO: Definição de um método da classe.
  Future<List<Leitura>> carregarLeiturasDeTanque(int tanqueId) async {
    // POO: Delega a chamada para o método 'buscarLeiturasPorTanque' do serviço.
    return await _producaoService.buscarLeiturasPorTanque(tanqueId);
  }

  // -------------------------------------------------------------------
  // MÉTODOS DE EXIBIÇÃO (Usam os métodos de busca acima e formatam a saída)
  // -------------------------------------------------------------------

  /// Lista geral sem filtros.
  // POO: Definição de um método da classe.
  // LÓGICA: Método assíncrono ('async') que não retorna valor ('void').
  // Sua função é apenas realizar uma ação (imprimir no console).
  Future<void> listarRegistrosDeProducao() async {
    // LÓGICA: Imprime um cabeçalho no console (I/O).
    print('\n📈 RELATÓRIO DE PRODUÇÃO (GERAL)');
    print('═' * 60);

    // LÓGICA: Bloco 'try/catch' para tratamento de erros.
    try {
      // POO: Chama um outro método ('carregarTodosRegistros') desta *mesma* classe.
      // LÓGICA: 'await' espera a busca terminar.
      final registros = await carregarTodosRegistros();

      // LÓGICA: Estrutura condicional (if) para verificar se a lista está vazia.
      if (registros.isEmpty) {
        print('📭 Nenhum registro encontrado.');
        // LÓGICA: 'return' para sair do método (saída antecipada).
        return;
      }

      // LÓGICA: Inicia um loop 'for-each' para iterar sobre a lista.
      for (final p in registros) {
        // POO: Chama o método 'exibirDados()' em cada objeto 'p' (Producao).
        // O próprio objeto 'Producao' sabe como se "imprimir".
        p.exibirDados();
        // LÓGICA: Imprime um separador.
        print('─' * 40);
      }

      // LÓGICA: Imprime um rodapé com o total.
      print('📊 Total de registros: ${registros.length}');
    } catch (e) {
      // LÓGICA: Bloco 'catch' que captura qualquer erro que ocorreu no 'try'.
      print('❌ Erro ao listar registros de produção: $e');
    }
  }

  /// Lista filtrada por mês/ano.
  // POO: Definição de um método da classe.
  Future<void> listarProducaoFiltrada(int mes, int ano) async {
    // LÓGICA: Imprime cabeçalho (I/O) usando interpolação de string.
    print('\n📈 RELATÓRIO DE PRODUÇÃO: $mes/$ano');
    print('═' * 60);

    // LÓGICA: Bloco 'try/catch' para tratamento de erros.
    try {
      // POO: Chama o método 'carregarPorPeriodo' desta *mesma* classe.
      // LÓGICA: 'await' espera a busca filtrada terminar.
      final registros = await carregarPorPeriodo(mes, ano);

      // LÓGICA: Condicional (if) para verificar se a lista está vazia.
      if (registros.isEmpty) {
        print('📭 Nenhum registro encontrado para $mes/$ano.');
        return; // LÓGICA: Saída antecipada.
      }

      // LÓGICA: Loop 'for-each' para iterar na lista filtrada.
      for (final p in registros) {
        // POO: Chama o método 'exibirDados()' em cada objeto 'p'.
        p.exibirDados();
        print('─' * 40); // LÓGICA: Separador.
      }

      // LÓGICA: Imprime rodapé com o total.
      print('📊 Total de registros no período: ${registros.length}');
    } catch (e) {
      // LÓGICA: Captura e imprime qualquer erro.
      print('❌ Erro ao listar produção por período: $e');
    }
  }
} // POO: Fim da definição da classe 'ProducaoController'.
