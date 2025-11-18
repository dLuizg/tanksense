// lib/services/sensor_service.dart
import '../models/sensor.dart';
import '../models/database/database_connection.dart';
import '../dao/sensor_dao.dart';

class SensorService {
  final SensorDao _dao;
  SensorService(DatabaseConnection db) : _dao = SensorDao(db);
  SensorService.fromDao(this._dao);

  Future<List<Sensor>> listar() async {
    return await _dao.fetchAll();
  }

  // --- INÍCIO DA MODIFICAÇÃO ---

  /// Valida e cadastra um sensor, retornando o objeto salvo.
  Future<Sensor?> cadastrar(Sensor sensor) async {
    // 1. Validações existentes (Boas!)
    if (sensor.tipo.trim().isEmpty || sensor.unidadeMedida.trim().isEmpty) {
      throw ArgumentError('Tipo e unidade de medida são obrigatórios');
    }

    // 2. CORREÇÃO DE BUG (RangeError): Validar a chave estrangeira
    // O Service é o local ideal para esta regra de negócio.
    if (sensor.dispositivoId <= 0) {
      throw ArgumentError(
          'A ID do dispositivo associado é inválida ou não foi fornecida.');
    }

    // 3. O _dao.insert agora retorna Future<Sensor?>,
    //    então nós simplesmente retornamos o resultado dele.
    return await _dao.insert(sensor);
  }

  /// Método 'criar' corrigido.
  Future<Sensor?> criar(String nome) async {
    final sensor = Sensor(0, nome, 'cm', 1); // dispositivoId placeholder

    // 4. Chamamos o 'cadastrar' (que agora retorna o objeto salvo)
    //    e retornamos esse objeto (com ID).
    final sensorSalvo = await cadastrar(sensor);
    return sensorSalvo;
  }
  // --- FIM DA MODIFICAÇÃO ---
}
