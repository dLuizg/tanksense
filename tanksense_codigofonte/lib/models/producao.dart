// lib/producao.dart
import 'package:intl/intl.dart'; // (Isto funcionará após o 'dart pub get')
import 'entidade_base.dart';

class Producao extends EntidadeBase {
  final int idProducao;
  final int sensorId; // Chave estrangeira
  final DateTime dataHora;
  final double quantidade;
  final String tipoRegistro;
  final String detalhes;

  // --- INÍCIO DA CORREÇÃO ---
  // O construtor da classe mãe 'EntidadeBase' espera um
  // argumento POSICIONAL, e não NOMEADO.
  Producao(
    this.idProducao,
    this.sensorId,
    this.dataHora,
    this.quantidade,
    this.tipoRegistro,
    this.detalhes,
  ) : super(idProducao); // <-- CORRIGIDO: Era super(id: idProducao)
  // --- FIM DA CORREÇÃO ---

  // O BaseDAO precisa que toda entidade tenha um 'id'.
  @override
  int get id => idProducao;

  /// Implementação do contrato 'EntidadeBase' (exigido)
  @override
  String obterTipo() {
    // CORREÇÃO de Estilo: Removido 'this.' desnecessário
    return tipoRegistro;
  }

  /// Implementação do contrato 'EntidadeBase' (exigido)
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

  /// Cria uma cópia deste objeto, substituindo os campos fornecidos.
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

  /// Construtor Factory para criar a partir de um Map (vindo do banco)
  factory Producao.fromMap(Map<String, dynamic> map) {
    // --- INÍCIO DA CORREÇÃO ---
    // Tornamos o construtor defensivo contra valores NULL do banco.

    return Producao(
      // CORREÇÃO: Lida com IDs nulos (define 0 como padrão)
      (map['idProducao'] as num?)?.toInt() ?? 0,
      (map['sensor_idSensor'] as num?)?.toInt() ?? 0,

      // CORREÇÃO: Lida com Timestamps nulos (define 1970 como padrão)
      // Esta é a correção para o erro: 'type 'Null' is not a subtype of type 'DateTime''
      (map['timestamp'] as DateTime?) ?? DateTime(1970),

      // CORREÇÃO: Lida com Quantidade nula (define 0.0 como padrão)
      (map['quantidade'] as num?)?.toDouble() ?? 0.0,

      map['tipoRegistro'] ?? 'N/A', // (Isto já estava correto)
      map['detalhes'] ?? 'N/A', // (Isto já estava correto)
    );
    // --- FIM DA CORREÇÃO ---
  }

  /// Método para exibir dados (usado na listagem)
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
