// lib/models/dispositivo.dart
import 'entidade_base.dart';

// POO: Classe Dispositivo que herda de EntidadeBase
// Demonstra herança e especialização de comportamento
class Dispositivo extends EntidadeBase {
  final String _modelo;
  final String _status;
  final List<String> _historicoStatus = [];

  // POO: Construtor que inicializa atributos e chama o construtor da classe pai
  // LÓGICA: Registra o status inicial no histórico ao criar o dispositivo
  Dispositivo(super.id, this._modelo, this._status) {
    _historicoStatus.add("Criado: $_status");
  }

  // POO: Getters para acesso controlado aos atributos privados
  String get modelo => _modelo;
  String get status => _status;
  String get nome => _modelo; 
  List<String> get historicoStatus => List.unmodifiable(_historicoStatus);

  // POO: Sobrescrita do método abstrato da classe base
  // LÓGICA: Implementa a exibição específica dos dados do dispositivo
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

  // POO: Implementação do método abstrato para retornar o tipo da entidade
  @override
  String obterTipo() {
    return "Dispositivo IoT";
  }

  // LÓGICA: Método para atualizar o status com validações e registro histórico
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

  // LÓGICA: Exibe todo o histórico de mudanças de status do dispositivo
  void exibirHistorico() {
    print('📋 Histórico de Status:');
    for (String evento in _historicoStatus) {
      print('  📍 $evento');
    }
  }

  // LÓGICA: Método utilitário que verifica se o dispositivo está ativo
  bool estaAtivo() {
    return _status.toLowerCase() == 'ativo';
  }

  // POO: Implementação do método para converter objeto em mapa
  // Útil para serialização e persistência de dados
  @override
  Map<String, dynamic> toMap() {
    return {
      'idDispositivo': id,
      'modelo': _modelo,
      'status': _status,
      'historico': _historicoStatus,
    };
  }

  // POO: Sobrescrita do método toString para representação textual do objeto
  @override
  String toString() {
    return 'Dispositivo{id: $id, modelo: $_modelo, status: $_status}';
  }
}