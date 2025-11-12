// lib/models/leitura.dart
import 'entidade_base.dart';

// POO: Classe Leitura que herda de EntidadeBase
// Representa uma leitura de sensor com dados de medição e timestamp
class Leitura extends EntidadeBase {
  final DateTime _timestamp;
  final double _distanciaCm;
  final double _nivelCm;
  final double _porcentagem;
  final String _status;
  final String _unidade;

  // POO: Construtor principal que inicializa todos os atributos finais
  Leitura(
    super.id,
    this._timestamp,
    this._distanciaCm,
    this._nivelCm,
    this._porcentagem,
    this._status,
    this._unidade,
  );

  // POO: Factory constructor para criação de objetos a partir de dados do Firebase
  // LÓGICA: Processa dados brutos com múltiplos formatos e validações robustas
  factory Leitura.fromFirebase(Map<String, dynamic> data, String id) {
    DateTime timestamp;

    // LÓGICA: Processamento complexo do timestamp com múltiplos formatos suportados
    try {
      final timestampData = data['timestamp'];

      if (timestampData == null) {
        timestamp = DateTime.now().toUtc();
      } else if (timestampData is String && timestampData.contains('T')) {
        // Formato ISO 8601
        try {
          timestamp = DateTime.parse(timestampData).toUtc();
        } catch (e) {
          timestamp = DateTime.now().toUtc();
        }
      } else if (timestampData is String && timestampData.contains('/')) {
        // Formato personalizado DD/MM/AAAA HH:MM:SS
        try {
          final parts = timestampData.split(' ');
          if (parts.length == 2) {
            final dateParts = parts[0].split('/');
            final timeParts = parts[1].split(':');

            if (dateParts.length == 3 && timeParts.length == 3) {
              timestamp = DateTime(
                int.parse(dateParts[2]), // ano
                int.parse(dateParts[1]), // mês
                int.parse(dateParts[0]), // dia
                int.parse(timeParts[0]), // hora
                int.parse(timeParts[1]), // minuto
                int.parse(timeParts[2]), // segundo
              ).toUtc();
            } else {
              timestamp = DateTime.now().toUtc();
            }
          } else {
            timestamp = DateTime.now().toUtc();
          }
        } catch (e) {
          timestamp = DateTime.now().toUtc();
        }
      } else if (timestampData is int || timestampData is double) {
        // Timestamp em milissegundos
        try {
          timestamp = DateTime.fromMillisecondsSinceEpoch(
            timestampData.toInt(),
            isUtc: true,
          );
        } catch (e) {
          timestamp = DateTime.now().toUtc();
        }
      } else {
        timestamp = DateTime.now().toUtc();
      }
    } catch (e) {
      timestamp = DateTime.now().toUtc();
    }

    // LÓGICA: Conversão e validação dos dados numéricos com tratamento de tipos
    double distanciaCm = 0.0;
    double nivelCm = 0.0;
    double porcentagem = 0.0;
    String status = 'Desconhecido';
    String unidade = 'cm';

    try {
      // Processamento da distância com suporte a múltiplos tipos de dados
      if (data['distancia_cm'] != null) {
        if (data['distancia_cm'] is double) {
          distanciaCm = data['distancia_cm'];
        } else if (data['distancia_cm'] is int) {
          distanciaCm = data['distancia_cm'].toDouble();
        } else if (data['distancia_cm'] is String) {
          distanciaCm = double.tryParse(data['distancia_cm']) ?? 0.0;
        }
      }

      // Processamento do nível
      if (data['nivel_cm'] != null) {
        if (data['nivel_cm'] is double) {
          nivelCm = data['nivel_cm'];
        } else if (data['nivel_cm'] is int) {
          nivelCm = data['nivel_cm'].toDouble();
        } else if (data['nivel_cm'] is String) {
          nivelCm = double.tryParse(data['nivel_cm']) ?? 0.0;
        }
      }

      // Processamento da porcentagem com validação implícita
      if (data['porcentagem'] != null) {
        if (data['porcentagem'] is double) {
          porcentagem = data['porcentagem'];
        } else if (data['porcentagem'] is int) {
          porcentagem = data['porcentagem'].toDouble();
        } else if (data['porcentagem'] is String) {
          porcentagem = double.tryParse(data['porcentagem']) ?? 0.0;
        }
      }

      // Processamento de campos textuais
      if (data['status'] != null) status = data['status'].toString();
      if (data['unidade'] != null) unidade = data['unidade'].toString();
    } catch (e) {
      print('❌ Erro ao converter dados: $e');
    }

    // LÓGICA: Geração segura de ID com fallback para timestamp atual
    int safeId = int.tryParse(id) ?? DateTime.now().millisecondsSinceEpoch;

    return Leitura(
      safeId,
      timestamp,
      distanciaCm,
      nivelCm,
      porcentagem,
      status,
      unidade,
    );
  }

  // POO: Getters para acesso controlado aos atributos privados
  DateTime get timestamp => _timestamp;
  double get distanciaCm => _distanciaCm;
  double get nivelCm => _nivelCm;
  double get porcentagem => _porcentagem;
  String get status => _status;
  String get unidade => _unidade;

  // Getters para compatibilidade com interface esperada
  double get valor => _nivelCm;
  int get tanqueId => 1;
  DateTime get dataHora => _timestamp;

  // LÓGICA: Método para comparar se duas leituras têm exatamente o mesmo timestamp
  // Útil para evitar duplicatas em processamento de dados
  bool temMesmoTimestamp(Leitura outra) {
    return _timestamp.isAtSameMomentAs(outra._timestamp);
  }

  // LÓGICA: Getter que valida se os dados da leitura são consistentes e válidos
  bool get isValid {
    return _distanciaCm > 0 &&
        _nivelCm >= 0 &&
        _porcentagem >= 0 &&
        _porcentagem <= 100 &&
        _status.isNotEmpty;
  }

  // POO: Implementação do método abstrato para exibição formatada dos dados
  @override
  void exibirDados() {
    print('📊 LEITURA - ${_formatarData(_timestamp)}');
    print('─' * 35);
    print('ID: $id');
    print('Distância: ${_distanciaCm.toStringAsFixed(1)} $_unidade');
    print('Nível: ${_nivelCm.toStringAsFixed(1)} $_unidade');
    print('Porcentagem: ${_porcentagem.toStringAsFixed(1)}%');
    print('Status: $_status');
    print('─' * 35);
  }

  // POO: Implementação do método abstrato para identificar o tipo de entidade
  @override
  String obterTipo() {
    return "Leitura de Sensor";
  }

  // LÓGICA: Método privado para formatação de data no padrão brasileiro
  String _formatarData(DateTime data) {
    try {
      final localTime = data.toLocal();
      return '${localTime.day.toString().padLeft(2, '0')}/${localTime.month.toString().padLeft(2, '0')}/${localTime.year} '
          '${localTime.hour.toString().padLeft(2, '0')}:${localTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Data inválida';
    }
  }

  // POO: Sobrescrita do toString para representação resumida da leitura
  @override
  String toString() {
    return '${_formatarData(_timestamp)} - ${_porcentagem.toStringAsFixed(1)}% - $_status';
  }

  // POO: Implementação do método para serialização em mapa
  @override
  Map<String, dynamic> toMap() {
    return {
      'idLeitura': id,
      'timestamp': _timestamp.toIso8601String(),
      'distanciaCm': _distanciaCm,
      'nivelCm': _nivelCm,
      'porcentagem': _porcentagem,
      'status': _status,
      'unidade': _unidade,
    };
  }

  // LÓGICA: Getter que fornece timestamp em formato string para uso como chave única
  String get timestampString {
    return _timestamp.toIso8601String();
  }
}