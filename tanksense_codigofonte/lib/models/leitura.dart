// leitura.dart
import 'entidade_base.dart';

class Leitura extends EntidadeBase {
  final DateTime _timestamp;
  final double _distanciaCm;
  final double _nivelCm;
  final double _porcentagem;
  final String _status;
  final String _unidade;

  Leitura(
    super.id,
    this._timestamp,
    this._distanciaCm,
    this._nivelCm,
    this._porcentagem,
    this._status,
    this._unidade,
  );

  factory Leitura.fromFirebase(Map<String, dynamic> data, String id) {
    DateTime timestamp;

    try {
      final timestampData = data['timestamp'];

      if (timestampData == null) {
        timestamp = DateTime.now().toUtc();
      } else if (timestampData is String && timestampData.contains('T')) {
        try {
          timestamp = DateTime.parse(timestampData).toUtc();
        } catch (e) {
          timestamp = DateTime.now().toUtc();
        }
      } else if (timestampData is String && timestampData.contains('/')) {
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

    // Converter dados numéricos
    double distanciaCm = 0.0;
    double nivelCm = 0.0;
    double porcentagem = 0.0;
    String status = 'Desconhecido';
    String unidade = 'cm';

    try {
      // Distância
      if (data['distancia_cm'] != null) {
        if (data['distancia_cm'] is double) {
          distanciaCm = data['distancia_cm'];
        } else if (data['distancia_cm'] is int) {
          distanciaCm = data['distancia_cm'].toDouble();
        } else if (data['distancia_cm'] is String) {
          distanciaCm = double.tryParse(data['distancia_cm']) ?? 0.0;
        }
      }

      // Nível
      if (data['nivel_cm'] != null) {
        if (data['nivel_cm'] is double) {
          nivelCm = data['nivel_cm'];
        } else if (data['nivel_cm'] is int) {
          nivelCm = data['nivel_cm'].toDouble();
        } else if (data['nivel_cm'] is String) {
          nivelCm = double.tryParse(data['nivel_cm']) ?? 0.0;
        }
      }

      // Porcentagem
      if (data['porcentagem'] != null) {
        if (data['porcentagem'] is double) {
          porcentagem = data['porcentagem'];
        } else if (data['porcentagem'] is int) {
          porcentagem = data['porcentagem'].toDouble();
        } else if (data['porcentagem'] is String) {
          porcentagem = double.tryParse(data['porcentagem']) ?? 0.0;
        }
      }

      // Status e Unidade
      if (data['status'] != null) status = data['status'].toString();
      if (data['unidade'] != null) unidade = data['unidade'].toString();
    } catch (e) {
      print('❌ Erro ao converter dados: $e');
    }

    // Gerar ID
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

  // Getters
  DateTime get timestamp => _timestamp;
  double get distanciaCm => _distanciaCm;
  double get nivelCm => _nivelCm;
  double get porcentagem => _porcentagem;
  String get status => _status;
  String get unidade => _unidade;

  // Getters para compatibilidade
  double get valor => _nivelCm;
  int get tanqueId => 1;
  DateTime get dataHora => _timestamp;

  // VERIFICAÇÃO DE TIMESTAMP - MÉTODO PRINCIPAL
  bool temMesmoTimestamp(Leitura outra) {
    return _timestamp.isAtSameMomentAs(outra._timestamp);
  }

  // Verificar se é válida
  bool get isValid {
    return _distanciaCm > 0 &&
        _nivelCm >= 0 &&
        _porcentagem >= 0 &&
        _porcentagem <= 100 &&
        _status.isNotEmpty;
  }

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

  @override
  String obterTipo() {
    return "Leitura de Sensor";
  }

  String _formatarData(DateTime data) {
    try {
      final localTime = data.toLocal();
      return '${localTime.day.toString().padLeft(2, '0')}/${localTime.month.toString().padLeft(2, '0')}/${localTime.year} '
          '${localTime.hour.toString().padLeft(2, '0')}:${localTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Data inválida';
    }
  }

  @override
  String toString() {
    return '${_formatarData(_timestamp)} - ${_porcentagem.toStringAsFixed(1)}% - $_status';
  }

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

  // Método para timestamp em string (usar como chave única)
  String get timestampString {
    return _timestamp.toIso8601String();
  }
}
