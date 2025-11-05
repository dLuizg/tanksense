// lib/controllers/gestao_equipamentos_controller.dart
import '../models/tanque.dart';
import '../models/dispositivo.dart';
import '../models/sensor.dart';
import '../services/tanque_service.dart';
import '../services/dispositivo_service.dart';
import '../services/sensor_service.dart';

class GestaoEquipamentosController {
  final TanqueService _tanqueService;
  final DispositivoService _dispositivoService;
  final SensorService _sensorService;

  GestaoEquipamentosController(
    this._tanqueService,
    this._dispositivoService,
    this._sensorService,
  );

  Future<Tanque?> cadastrarTanque(double altura, double volumeMax,
      double volumeAtual, int localId, int dispositivoId) async {
    print('Controller: Cadastrando tanque...');
    try {
      final novoTanque = Tanque(0, altura, volumeMax, volumeAtual);

      // CORREÇÃO: Chamamos o service (que retorna void/int)
      await _tanqueService.cadastrar(novoTanque, localId, dispositivoId);

      // Retornamos o objeto local (com ID 0)
      return novoTanque;
    } catch (e) {
      print('❌ Erro no cadastro do tanque: $e');
      return null;
    }
  }

  Future<Dispositivo?> cadastrarDispositivo(
      String modelo, String status, int localId) async {
    print('Controller: Cadastrando dispositivo...');
    try {
      final novoDispositivo = Dispositivo(0, modelo, status);

      // CORREÇÃO: Chamamos o service (que retorna void/int)
      await _dispositivoService.cadastrar(novoDispositivo);

      // Retornamos o objeto local (com ID 0)
      return novoDispositivo;
    } catch (e) {
      print('❌ Erro no cadastro do dispositivo: $e');
      return null;
    }
  }

  Future<Sensor?> cadastrarSensor(
      String tipo, String unidadeMedida, int dispositivoId) async {
    print('Controller: Cadastrando sensor...');
    try {
      final novoSensor = Sensor(0, tipo, unidadeMedida, dispositivoId);

      // CORREÇÃO: Chamamos o service (que retorna void/int)
      await _sensorService.cadastrar(novoSensor);

      // Retornamos o objeto local (com ID 0)
      return novoSensor;
    } catch (e) {
      print('❌ Erro no cadastro do sensor: $e');
      return null;
    }
  }
}
