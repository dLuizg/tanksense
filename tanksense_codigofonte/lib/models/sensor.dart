// lib/models/sensor.dart
import 'entidade_base.dart';

// POO: Classe Sensor que herda de EntidadeBase
// Representa um sensor no sistema de monitoramento de tanques
class Sensor extends EntidadeBase {
  final String _tipo;
  final String _unidadeMedida;
  final int _dispositivoId;
  final List<double> _leiturasRecentes = [];

  // POO: Construtor que inicializa os atributos do sensor
  Sensor(super.id, this._tipo, this._unidadeMedida, this._dispositivoId);

  // POO: Getters para acesso controlado aos atributos privados
  String get tipo => _tipo;
  String get unidadeMedida => _unidadeMedida;
  int get dispositivoId => _dispositivoId;
  String get nome => _tipo; 
  List<double> get leiturasRecentes => List.unmodifiable(_leiturasRecentes);

  // POO: Implementação do método abstrato para exibição dos dados do sensor
  @override
  void exibirDados() {
    print('📡 DADOS DO SENSOR');
    print('─' * 30);
    print('ID: $id');
    print('Tipo: $_tipo');
    print('Unidade: $_unidadeMedida');
    print('Dispositivo ID: $_dispositivoId');
    print('Leituras: ${_leiturasRecentes.length}');
    print('Tipo: ${obterTipo()}');
    print('─' * 30);
  }

  // POO: Implementação do método abstrato para identificar o tipo de entidade
  @override
  String obterTipo() {
    return "Sensor";
  }

  // LÓGICA: Simula a coleta de dados do sensor com valores aleatórios
  // Gera valores entre 20.0 e 50.0 baseados no tempo atual
  double coletarDado() {
    return (20.0 + (DateTime.now().millisecond % 30)).toDouble();
  }

  // LÓGICA: Simula múltiplas leituras do sensor com buffer limitado
  // Mantém apenas as 10 leituras mais recentes (padrão de buffer circular)
  void simularLeituras(int quantidade) {
    // LÓGICA: Função interna para adicionar leitura com controle de tamanho
    void adicionarLeitura(double valor) {
      _leiturasRecentes.add(valor);
      if (_leiturasRecentes.length > 10) {
        _leiturasRecentes.removeAt(0); // Remove a leitura mais antiga
      }
    }

    for (int i = 0; i < quantidade; i++) {
      double leitura = coletarDado();
      adicionarLeitura(leitura);
    }
  }

  // LÓGICA: Calcula a média das leituras recentes do sensor
  double calcularMedia() {
    if (_leiturasRecentes.isEmpty) return 0.0;

    double soma = 0.0;
    for (double leitura in _leiturasRecentes) {
      soma += leitura;
    }
    return soma / _leiturasRecentes.length;
  }

  // LÓGICA: Calcula distância baseada no tempo de eco (para sensores ultrassônicos)
  // Usa a fórmula: distância = (velocidade do som × tempo de eco) / 2
  double calcularDistancia(double tempoEco) {
    const double velocidadeSom = 343.0;
    return (velocidadeSom * tempoEco) / 2;
  }

  // POO: Implementação do método para serialização em mapa
  @override
  Map<String, dynamic> toMap() {
    return {
      'idSensor': id,
      'tipo': _tipo,
      'unidadeMedida': _unidadeMedida,
      'dispositivoId': _dispositivoId,
      'leiturasRecentes': _leiturasRecentes,
    };
  }
}