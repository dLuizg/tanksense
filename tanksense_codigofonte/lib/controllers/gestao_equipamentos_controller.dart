// lib/controllers/gestao_equipamentos_controller.dart

// POO: Importando as classes (modelos) que definem a estrutura dos dados.
import '../models/tanque.dart';
import '../models/dispositivo.dart';
import '../models/sensor.dart';

// POO: Importando as classes de Serviço (que encapsulam as regras de negócio).
import '../services/tanque_service.dart';
import '../services/dispositivo_service.dart';
import '../services/sensor_service.dart';

// POO: Definição da classe 'GestaoEquipamentosController'.
// Esta classe agrupa a lógica de *gerenciamento* (cadastro) de equipamentos.
class GestaoEquipamentosController {
  // POO: Declaração de atributos (campos) privados e finais.
  // Cada atributo armazena uma instância de um Serviço.
  final TanqueService _tanqueService;
  final DispositivoService _dispositivoService;
  final SensorService _sensorService;

  // POO: Construtor da classe.
  // Utiliza Injeção de Dependência para receber as instâncias dos serviços
  // que ele precisa para funcionar.
  GestaoEquipamentosController(
    this._tanqueService,
    this._dispositivoService,
    this._sensorService,
  );

  // POO: Definição de um método da classe.
  // LÓGICA: Método assíncrono ('async') que pode retornar um objeto 'Tanque' ou 'null'.
  Future<Tanque?> cadastrarTanque(double altura, double volumeMax,
      double volumeAtual, int localId, int dispositivoId) async {
    // LÓGICA: Imprime no console para fins de debug.
    print('Controller: Cadastrando tanque...');
    // LÓGICA: Inicia um bloco 'try/catch' para tratamento de erros.
    try {
      // POO: Cria uma nova instância (objeto) da classe 'Tanque' na memória.
      // LÓGICA: O ID '0' é usado como um valor temporário (placeholder).
      final novoTanque = Tanque(0, altura, volumeMax, volumeAtual);

      // POO: Chama o método 'cadastrar' do objeto '_tanqueService'.
      // LÓGICA: 'await' pausa a execução aqui até que o serviço
      // (que fala com o banco) termine a sua tarefa.
      await _tanqueService.cadastrar(novoTanque, localId, dispositivoId);

      // LÓGICA: Retorna o objeto 'novoTanque' que foi criado localmente.
      // (Nota: Este objeto ainda está com o ID 0, não o ID real do banco).
      return novoTanque;
    } catch (e) {
      // LÓGICA: Bloco 'catch' é executado se qualquer erro ocorrer no 'try'.
      print('❌ Erro no cadastro do tanque: $e');
      // LÓGICA: Retorna 'null' para sinalizar que o cadastro falhou.
      return null;
    }
  }

  // POO: Definição de um método da classe.
  // LÓGICA: Método assíncrono ('async') que pode retornar um 'Dispositivo' ou 'null'.
  Future<Dispositivo?> cadastrarDispositivo(
      String modelo, String status, int localId) async {
    // LÓGICA: Imprime no console para fins de debug.
    print('Controller: Cadastrando dispositivo...');
    // LÓGICA: Inicia um bloco 'try/catch' para tratamento de erros.
    try {
      // POO: Cria uma nova instância (objeto) da classe 'Dispositivo'.
      final novoDispositivo = Dispositivo(0, modelo, status);

      // POO: Chama o método 'cadastrar' do objeto '_dispositivoService'.
      // LÓGICA: 'await' pausa a execução até o serviço terminar.
      await _dispositivoService.cadastrar(novoDispositivo);

      // LÓGICA: Retorna o objeto 'novoDispositivo' criado localmente (com ID 0).
      return novoDispositivo;
    } catch (e) {
      // LÓGICA: Bloco 'catch' para capturar falhas.
      print('❌ Erro no cadastro do dispositivo: $e');
      // LÓGICA: Retorna 'null' para sinalizar a falha.
      return null;
    }
  }

  // POO: Definição de um método da classe.
  // LÓGICA: Método assíncrono ('async') que pode retornar um 'Sensor' ou 'null'.
  Future<Sensor?> cadastrarSensor(
      String tipo, String unidadeMedida, int dispositivoId) async {
    // LÓGICA: Imprime no console para fins de debug.
    print('Controller: Cadastrando sensor...');
    // LÓGICA: Inicia um bloco 'try/catch' para tratamento de erros.
    try {
      // POO: Cria uma nova instância (objeto) da classe 'Sensor'.
      final novoSensor = Sensor(0, tipo, unidadeMedida, dispositivoId);

      // POO: Chama o método 'cadastrar' do objeto '_sensorService'.
      // LÓGICA: 'await' pausa a execução até o serviço terminar.
      await _sensorService.cadastrar(novoSensor);

      // LÓGICA: Retorna o objeto 'novoSensor' criado localmente (com ID 0).
      return novoSensor;
    } catch (e) {
      // LÓGICA: Bloco 'catch' para capturar falhas.
      print('❌ Erro no cadastro do sensor: $e');
      // LÓGICA: Retorna 'null' para sinalizar a falha.
      return null;
    }
  }
} // POO: Fim da definição da classe 'GestaoEquipamentosController'.
