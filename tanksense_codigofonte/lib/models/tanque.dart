// lib/models/tanque.dart
import 'entidade_base.dart';

// POO: Classe Tanque que herda de EntidadeBase
// Representa um tanque de armazenamento no sistema de monitoramento
class Tanque extends EntidadeBase {
  final double _altura;
  final double _volumeMax;
  double _volumeAtual;
  final Map<DateTime, double> _historicoVolume = {};

  // POO: Construtor que inicializa os atributos e registra o volume inicial no histórico
  Tanque(super.id, this._altura, this._volumeMax, this._volumeAtual) {
    _historicoVolume[DateTime.now()] = _volumeAtual;
  }

  // POO: Getters para acesso controlado aos atributos privados
  double get altura => _altura;
  double get volumeMax => _volumeMax;
  double get volumeAtual => _volumeAtual;
  String get nome => 'Tanque $id'; // Alias para compatibilidade
  Map<DateTime, double> get historicoVolume =>
      Map.unmodifiable(_historicoVolume);

  // POO: Setter com validação para controle seguro do volume atual
  // LÓGICA: Valida se o volume está dentro dos limites e registra no histórico
  set volumeAtual(double volume) {
    if (volume >= 0 && volume <= _volumeMax) {
      _volumeAtual = volume;
      _historicoVolume[DateTime.now()] = volume;
    } else {
      print('❌ Volume inválido! Deve estar entre 0 e $_volumeMax');
    }
  }

  // POO: Implementação do método abstrato para exibição dos dados do tanque
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

  // POO: Implementação do método abstrato para identificar o tipo de entidade
  @override
  String obterTipo() {
    return "Tanque de Armazenamento";
  }

  // LÓGICA: Calcula a porcentagem de capacidade atual do tanque
  double calcularCapacidade() {
    return (_volumeAtual / _volumeMax) * 100;
  }

  // LÓGICA: Adiciona volume ao tanque com validações de limite
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

  // LÓGICA: Remove volume do tanque com validações de disponibilidade
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

  // LÓGICA: Exibe o histórico completo de alterações de volume
  void exibirHistoricoVolume() {
    print('📊 Histórico de Volume:');
    _historicoVolume.forEach((data, volume) {
      print('  📅 ${_formatarData(data)}: ${volume}L');
    });
  }

  // LÓGICA: Formata a data para exibição no histórico (apenas hora:minuto)
  String _formatarData(DateTime data) {
    return '${data.hour}:${data.minute.toString().padLeft(2, '0')}';
  }

  // LÓGICA: Métodos utilitários para verificar estado do tanque
  bool estaVazio() => _volumeAtual == 0;
  bool estaCheio() => _volumeAtual >= _volumeMax;

  // POO: Implementação do método para serialização em mapa
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

  // POO: Sobrescrita do método toString para representação textual
  @override
  String toString() {
    return 'Tanque{id: $id, altura: ${_altura}m, volumeMax: ${_volumeMax}L, volumeAtual: ${_volumeAtual}L}';
  }
}