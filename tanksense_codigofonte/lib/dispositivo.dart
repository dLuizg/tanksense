// dispositivo.dart
import 'entidade_base.dart';

class Dispositivo extends EntidadeBase {
  final String _modelo;
  final String _status;
  final List<String> _historicoStatus = [];

  Dispositivo(super.id, this._modelo, this._status) {
    _historicoStatus.add("Criado: $_status");
  }

  String get modelo => _modelo;
  String get status => _status;
  String get nome => _modelo; // Alias para compatibilidade
  List<String> get historicoStatus => List.unmodifiable(_historicoStatus);

  @override
  void exibirDados() {
    print('⚙️  DADOS DO DISPOSITIVO');
    print('─' * 30);
    print('ID: $id');
    print('Modelo: $_modelo');
    print('Status: $_status');
    print('Tipo: ${obterTipo()}');
    print('─' * 30);
  }

  @override
  String obterTipo() {
    return "Dispositivo IoT";
  }

  void atualizarStatus(String novoStatus) {
    if (novoStatus == _status) {
      print('⚠️  Status já está como $novoStatus');
    } else if (novoStatus.isEmpty) {
      print('❌ Status não pode ser vazio');
    } else {
      _historicoStatus.add("Alterado para: $novoStatus");
      print('✅ Status atualizado de $_status para $novoStatus');
    }
  }

  void exibirHistorico() {
    print('📋 Histórico de Status:');
    for (String evento in _historicoStatus) {
      print('  📍 $evento');
    }
  }

  bool estaAtivo() {
    return _status.toLowerCase() == 'ativo';
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'idDispositivo': id,
      'modelo': _modelo,
      'status': _status,
      'historico': _historicoStatus,
    };
  }

  @override
  String toString() {
    return 'Dispositivo{id: $id, modelo: $_modelo, status: $_status}';
  }
}
