// lib/services/producao_service.dart
import '../models/producao.dart';
import '../models/leitura.dart';
import '../models/database/database_connection.dart';
import '../dao/producao_dao.dart';

 // Injeção de dependência: o DAO depende da conexão com o banco
class ProducaoService {
  final ProducaoDao _dao;
  ProducaoService(DatabaseConnection db) : _dao = ProducaoDao(db);
  ProducaoService.fromDao(this._dao);

  // Recupera todas as produções cadastradas
  Future<List<Producao>> listarTodos() async {
    return await _dao.fetchAll();
  }

  // Lista produções dentro de um intervalo de tempo específico
  Future<List<Producao>> listarPorPeriodo(DateTime inicio, DateTime fim) async {
    return await _dao.fetchByPeriod(inicio, fim);
  }

  /// Lógica de Negócio: Calcula a produção com base na variação de leituras.
  /// (Responsabilidade correta do Service)
  List<Producao> calcularDeLeituras(List<Leitura> leituras) {
    final producoes = <Producao>[];
    // Começa a partir do índice 1, pois o cálculo compara leituras consecutiva
    for (int i = 1; i < leituras.length; i++) {
      final leituraAtual = leituras[i];
      final leituraAnterior = leituras[i - 1];
   // Diferença percentual entre duas leituras
      double variacaoPercentual =
          leituraAnterior.porcentagem - leituraAtual.porcentagem;
  // Apenas se houver redução no nível (produção efetiva)
      if (variacaoPercentual > 0) {
        double metrosFio = variacaoPercentual; // (Sua lógica de negócio)
        producoes.add(Producao(
          0, // ID 0 (temporário, será definido pelo DAO)
          0, // sensorId (será definido pelo enviarParaBanco)
          leituraAtual.timestamp,
          metrosFio,
          'Automática',
          'Leitura $i: ${variacaoPercentual.toStringAsFixed(2)}% = ${metrosFio.toStringAsFixed(2)}m de fio',
        ));
      }
    }
    return producoes;
  }

  // --- INÍCIO DAS MODIFICAÇÕES ---

  /// Cadastra uma única produção (Manual)
  Future<Producao?> cadastrarProducaoManual(Producao producao) async {
    // 1. CORREÇÃO (RangeError): Validar chave estrangeira
    if (producao.sensorId <= 0) {
      throw ArgumentError('A ID do sensor associado é inválida.');
    }
    if (producao.quantidade <= 0) {
      throw ArgumentError('A quantidade produzida deve ser positiva.');
    }

    // 2. CORREÇÃO (Fluxo POO): Usar o 'insert' que retorna ID
    // O 'insert' do BaseDAO retorna o novo ID
    final novoId = await _dao.insert(producao);
    if (novoId > 0) {
      // Retorna o objeto completo com o ID correto (POO ideal)
      return producao.copyWith(idProducao: novoId);
    }
    return null;
  }

  /// Envia produções calculadas (Automáticas) para o banco
  Future<int> enviarParaBanco(List<Producao> producoes, int sensorId) async {
    // 1. CORREÇÃO (RangeError): Validar chave estrangeira
    if (sensorId <= 0) {
      throw ArgumentError('A ID do sensor associado é inválida.');
    }
    if (producoes.isEmpty) {
      return 0; // Nada a fazer
    }

    // 2. CORREÇÃO (Fluxo POO): Retornar o resultado do DAO
    // O DAO agora retorna o número de linhas afetadas (int)
    return await _dao.insertMany(producoes, sensorId);
  }

  // --- MÉTODOS MOVIDOS/REMOVIDOS ---

  // (Este método 'buscarLeiturasPorTanque' precisa ser implementado
  // no LeituraService/LeituraDao)
  Future<List<Leitura>> buscarLeiturasPorTanque(int tanqueId) async {
    // ... (Implementação futura, talvez chamando LeituraService)
    return [];
  }

  Future<Producao?> gerarRegistroDiario(int tanqueId) async {
    // ... (A lógica aqui está OK, mas depende de buscarLeiturasPorTanque)
    final leituras = await buscarLeiturasPorTanque(tanqueId);
    if (leituras.isEmpty) return null;
    final producoes = calcularDeLeituras(leituras);
    if (producoes.isEmpty) return null;
    return producoes.first;
  }

  /* ❌ ESTES MÉTODOS FORAM REMOVIDOS DO SERVICE (Violação do SRP)
     Eles devem ser movidos para o Controller e para a View.

  Future<void> registrarProducao() async {
    // ... (Lógica de print e dados 'mágicos' removidos)
  }

  Future<void> listarProducao() async {
    // ... (Lógica de print removida)
  }
  */
}
