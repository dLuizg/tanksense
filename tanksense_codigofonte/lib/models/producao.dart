// lib/models/producao.dart
import 'package:intl/intl.dart'; // (Isto funcionará após o 'dart pub get')
import 'entidade_base.dart';

// POO: Classe Producao que herda de EntidadeBase
// Representa registros de produção no sistema de monitoramento
class Producao extends EntidadeBase {
  final int idProducao;
  final int sensorId; // Chave estrangeira
  final DateTime dataHora;
  final double quantidade;
  final String tipoRegistro;
  final String detalhes;

  // --- INÍCIO DA CORREÇÃO ---
  // POO: Construtor corrigido - a classe mãe espera argumento posicional
  // LÓGICA: O super deve receber o ID como parâmetro posicional, não nomeado
  Producao(
    this.idProducao,
    this.sensorId,
    this.dataHora,
    this.quantidade,
    this.tipoRegistro,
    this.detalhes,
  ) : super(idProducao);
  // --- FIM DA CORREÇÃO ---

  // POO: Getter que satisfaz o contrato da classe base EntidadeBase
  // LÓGICA: Retorna o idProducao como ID geral da entidade
  @override
  int get id => idProducao;

  /// POO: Implementação do método abstrato da classe base
  @override
  String obterTipo() {

    return tipoRegistro;
  }

  /// POO: Implementação do método para serialização em mapa
  /// LÓGICA: Converte o objeto para formato compatível com o banco de dados
  @override
  Map<String, dynamic> toMap() {
    // Converte o objeto em um mapa para o BaseDAO (se ele usar)
    return {
      'idProducao': idProducao,
      'sensor_idSensor': sensorId,
      'timestamp': dataHora.toIso8601String(),
      'quantidade': quantidade,
      'tipoRegistro': tipoRegistro,
      'detalhes': detalhes,
    };
  }

  /// POO: Método para criar cópia do objeto com campos atualizados (padrão Builder)
  /// LÓGICA: Útil para atualizações parciais sem modificar o objeto original
  Producao copyWith({
    int? idProducao,
    int? sensorId,
    DateTime? dataHora,
    double? quantidade,
    String? tipoRegistro,
    String? detalhes,
  }) {
    return Producao(
      idProducao ?? this.idProducao,
      sensorId ?? this.sensorId,
      dataHora ?? this.dataHora,
      quantidade ?? this.quantidade,
      tipoRegistro ?? this.tipoRegistro,
      detalhes ?? this.detalhes,
    );
  }

  /// POO: Factory constructor para criação a partir de dados do banco
  /// LÓGICA: Converte Map em objeto Producao com tratamento defensivo para nulos
  factory Producao.fromMap(Map<String, dynamic> map) {
    // --- INÍCIO DA CORREÇÃO ---
    // LÓGICA: Construtor defensivo contra valores NULL do banco
    // Previne erros de tipo quando o banco retorna valores nulos

    return Producao(
      // CORREÇÃO: Lida com IDs nulos (define 0 como padrão)
      (map['idProducao'] as num?)?.toInt() ?? 0,
      (map['sensor_idSensor'] as num?)?.toInt() ?? 0,

      // CORREÇÃO: Lida com Timestamps nulos (define 1970 como padrão)
      // Esta é a correção para o erro: 'type 'Null' is not a subtype of type 'DateTime''
      (map['timestamp'] as DateTime?) ?? DateTime(1970),

      // CORREÇÃO: Lida com Quantidade nula (define 0.0 como padrão)
      (map['quantidade'] as num?)?.toDouble() ?? 0.0,

      map['tipoRegistro'] ?? 'N/A', 
      map['detalhes'] ?? 'N/A', 
    );
    // --- FIM DA CORREÇÃO ---
  }

  /// LÓGICA: Método para exibição formatada dos dados de produção
  /// Usado nas interfaces de listagem para apresentação ao usuário
  @override
  void exibirDados() {
    final formatoData = DateFormat('dd/MM/yyyy HH:mm:ss');
    print('  ID Produção: $idProducao');
    print('  Data/Hora: ${formatoData.format(dataHora)}');
    print('  Quantidade: ${quantidade.toStringAsFixed(2)}m');
    print('  Tipo: $tipoRegistro');
    print('  Sensor ID: $sensorId');
    print('  Detalhes: $detalhes');
  }
}