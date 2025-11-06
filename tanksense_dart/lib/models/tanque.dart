// tanque.dart
import 'entidade_base.dart';

class Tanque extends EntidadeBase {
  final double _altura;
  final double _volumeMax;
  double _volumeAtual;
  final Map<DateTime, double> _historicoVolume = {};

  Tanque(super.id, this._altura, this._volumeMax, this._volumeAtual) {
    _historicoVolume[DateTime.now()] = _volumeAtual;
  }

  double get altura => _altura;
  double get volumeMax => _volumeMax;
  double get volumeAtual => _volumeAtual;
  String get nome => 'Tanque $id'; // Alias para compatibilidade
  Map<DateTime, double> get historicoVolume =>
      Map.unmodifiable(_historicoVolume);

  set volumeAtual(double volume) {
    if (volume >= 0 && volume <= _volumeMax) {
      _volumeAtual = volume;
      _historicoVolume[DateTime.now()] = volume;
    } else {
      print('❌ Volume inválido! Deve estar entre 0 e $_volumeMax');
    }
  }

  @override
  void exibirDados() {
    print('🛢️  DADOS DO TANQUE');
    print('─' * 30);
    print('ID: $id');
    print('Altura: ${_altura}m');
    print('Volume Máx: ${_volumeMax}L');
    print('Volume Atual: ${_volumeAtual}L');
    print('Capacidade: ${calcularCapacidade().toStringAsFixed(1)}%');
    print('Tipo: ${obterTipo()}');
    print('─' * 30);
  }

  @override
  String obterTipo() {
    return "Tanque de Armazenamento";
  }

  double calcularCapacidade() {
    return (_volumeAtual / _volumeMax) * 100;
  }

  void adicionarVolume(double volume) {
    if (volume > 0) {
      double novoVolume = _volumeAtual + volume;
      if (novoVolume <= _volumeMax) {
        volumeAtual = novoVolume;
        print('✅ Volume adicionado: ${volume}L');
      } else {
        print('❌ Volume excede a capacidade máxima!');
      }
    } else {
      print('❌ Volume deve ser positivo!');
    }
  }

  void removerVolume(double volume) {
    if (volume > 0) {
      if (volume <= _volumeAtual) {
        volumeAtual = _volumeAtual - volume;
        print('✅ Volume removido: ${volume}L');
      } else {
        print('❌ Volume insuficiente no tanque!');
      }
    } else {
      print('❌ Volume deve ser positivo!');
    }
  }

  void exibirHistoricoVolume() {
    print('📊 Histórico de Volume:');
    _historicoVolume.forEach((data, volume) {
      print('  📅 ${_formatarData(data)}: ${volume}L');
    });
  }

  String _formatarData(DateTime data) {
    return '${data.hour}:${data.minute.toString().padLeft(2, '0')}';
  }

  bool estaVazio() => _volumeAtual == 0;
  bool estaCheio() => _volumeAtual >= _volumeMax;

  @override
  Map<String, dynamic> toMap() {
    return {
      'idTanque': id,
      'altura': _altura,
      'volumeMax': _volumeMax,
      'volumeAtual': _volumeAtual,
      'capacidade': calcularCapacidade(),
    };
  }

  @override
  String toString() {
    return 'Tanque{id: $id, altura: ${_altura}m, volumeMax: ${_volumeMax}L, volumeAtual: ${_volumeAtual}L}';
  }
}
