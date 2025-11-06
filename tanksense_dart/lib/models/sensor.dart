// sensor.dart
import 'entidade_base.dart';

class Sensor extends EntidadeBase {
  final String _tipo;
  final String _unidadeMedida;
  final int _dispositivoId;
  final List<double> _leiturasRecentes = [];

  Sensor(super.id, this._tipo, this._unidadeMedida, this._dispositivoId);

  String get tipo => _tipo;
  String get unidadeMedida => _unidadeMedida;
  int get dispositivoId => _dispositivoId;
  String get nome => _tipo; // Alias para compatibilidade
  List<double> get leiturasRecentes => List.unmodifiable(_leiturasRecentes);

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

  @override
  String obterTipo() {
    return "Sensor";
  }

  double coletarDado() {
    return (20.0 + (DateTime.now().millisecond % 30)).toDouble();
  }

  void simularLeituras(int quantidade) {
    void adicionarLeitura(double valor) {
      _leiturasRecentes.add(valor);
      if (_leiturasRecentes.length > 10) {
        _leiturasRecentes.removeAt(0);
      }
    }

    for (int i = 0; i < quantidade; i++) {
      double leitura = coletarDado();
      adicionarLeitura(leitura);
    }
  }

  double calcularMedia() {
    if (_leiturasRecentes.isEmpty) return 0.0;

    double soma = 0.0;
    for (double leitura in _leiturasRecentes) {
      soma += leitura;
    }
    return soma / _leiturasRecentes.length;
  }

  double calcularDistancia(double tempoEco) {
    const double velocidadeSom = 343.0;
    return (velocidadeSom * tempoEco) / 2;
  }

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
