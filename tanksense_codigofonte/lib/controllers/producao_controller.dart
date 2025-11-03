// lib/controllers/producao_controller.dart

import '../producao.dart';
import '../leitura.dart';
import '../services/producao_service.dart';

class ProducaoController {
  final ProducaoService _producaoService;

  /// Construtor com injeção de dependência.
  ProducaoController(this._producaoService);

  // -------------------------------------------------------------------
  // MÉTODOS DE BUSCA
  // -------------------------------------------------------------------

  /// Busca todos os registros de produção.
  Future<List<Producao>> carregarTodosRegistros() async {
    return await _producaoService.listarTodos();
  }

  /// Busca registros de produção filtrados por mês e ano.
  Future<List<Producao>> carregarPorPeriodo(int mes, int ano) async {
    final inicio = DateTime(ano, mes, 1);
    final fim = DateTime(ano, mes + 1, 0); // Último dia do mês
    return await _producaoService.listarPorPeriodo(inicio, fim);
  }

  /// Busca leituras associadas a um tanque.
  Future<List<Leitura>> carregarLeiturasDeTanque(int tanqueId) async {
    return await _producaoService.buscarLeiturasPorTanque(tanqueId);
  }

  // -------------------------------------------------------------------
  // MÉTODOS DE EXIBIÇÃO (Chamados pelo Menu)
  // -------------------------------------------------------------------

  /// Lista geral sem filtros.
  Future<void> listarRegistrosDeProducao() async {
    print('\n📈 RELATÓRIO DE PRODUÇÃO (GERAL)');
    print('═' * 60);

    try {
      final registros = await carregarTodosRegistros();

      if (registros.isEmpty) {
        print('📭 Nenhum registro encontrado.');
        return;
      }

      for (final p in registros) {
        p.exibirDados();
        print('─' * 40);
      }

      print('📊 Total de registros: ${registros.length}');
    } catch (e) {
      print('❌ Erro ao listar registros de produção: $e');
    }
  }

  /// Lista filtrada por mês/ano.
  Future<void> listarProducaoFiltrada(int mes, int ano) async {
    print('\n📈 RELATÓRIO DE PRODUÇÃO: $mes/$ano');
    print('═' * 60);

    try {
      final registros = await carregarPorPeriodo(mes, ano);

      if (registros.isEmpty) {
        print('📭 Nenhum registro encontrado para $mes/$ano.');
        return;
      }

      for (final p in registros) {
        p.exibirDados();
        print('─' * 40);
      }

      print('📊 Total de registros no período: ${registros.length}');
    } catch (e) {
      print('❌ Erro ao listar produção por período: $e');
    }
  }
}
