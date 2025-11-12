// lib/dao/sensor_dao.dart
import '../models/database_connection.dart';
import '../models/sensor.dart';

class SensorDao {
  final DatabaseConnection db;
  SensorDao(this.db);

  Future<List<Sensor>> fetchAll() async {
    final sensores = <Sensor>[];
    try {
      var resultados = await db.connection!.query('SELECT * FROM sensor');
      for (var row in resultados) {
        var dados = row.toList();
        if (dados.length >= 3) {
          final id = (dados[0] as num).toInt();
          final tipo = dados[1].toString();
          final unidade = dados[2].toString();
          final dispositivoId =
              dados.length >= 4 ? (dados[3] as num).toInt() : 0;
          sensores.add(Sensor(id, tipo, unidade, dispositivoId));
        }
      }
    } catch (e) {
      print('❌ Erro ao carregar sensores: $e');
    }
    return sensores;
  }

  Future<Sensor?> insert(Sensor sensor) async {
    try {
      var resultado = await db.connection!.query(
        'INSERT INTO sensor (tipo, unidadeMedida, dispositivo_idDispositivo) VALUES (?, ?, ?)',
        [sensor.tipo, sensor.unidadeMedida, sensor.dispositivoId],
      );

      final int? newId = resultado.insertId;

      if (newId != null && newId > 0) {
        return Sensor(
          newId,
          sensor.tipo,
          sensor.unidadeMedida,
          sensor.dispositivoId,
        );
      }
      return null;
    } catch (e) {
      print('❌ Erro ao salvar sensor: $e');
      rethrow;
    }
  }
}
