// lib/dao/leitura_dao.dart
import '../models/database_connection.dart';
import '../models/leitura.dart';

class LeituraDao {
  final DatabaseConnection db;
  LeituraDao(this.db);

  Future<List<Leitura>> fetchAll() async {
    final leituras = <Leitura>[];
    try {
      final resultados = await db.connection!.query('''
        SELECT idLeitura, timestamp, distanciaCm, nivelCm, porcentagem, statusTanque 
        FROM leitura 
        ORDER BY timestamp DESC
      ''');

      for (var row in resultados) {
        final timestamp = (row.fields['timestamp'] as DateTime).toUtc();

        leituras.add(Leitura(
          row.fields['idLeitura'] as int,
          timestamp,
          (row.fields['distanciaCm'] as num).toDouble(),
          (row.fields['nivelCm'] as num).toDouble(),
          (row.fields['porcentagem'] as num).toDouble(),
          row.fields['statusTanque'] as String,
          'cm',
        ));
      }
    } catch (e) {
      print('❌ Erro ao buscar leituras do MySQL: $e');
    }
    return leituras;
  }

  Future<int> insertMany(List<Leitura> leituras, int sensorId) async {
    int count = 0;
    for (final leitura in leituras) {
      try {
        await db.connection!.query(
          '''INSERT INTO leitura
           (timestamp, distanciaCm, nivelCm, porcentagem, statusTanque, sensor_idSensor)
           VALUES (?, ?, ?, ?, ?, ?)''',
          [
            _formatarDataParaMySQL(leitura.timestamp),
            leitura.distanciaCm,
            leitura.nivelCm,
            leitura.porcentagem,
            leitura.status,
            sensorId,
          ],
        );
        count++;
      } catch (e) {
        print('❌ Erro: ${leitura.timestamp} - $e');
      }
    }
    return count;
  }

  String _formatarDataParaMySQL(DateTime dateTime) {
    return dateTime.toIso8601String().substring(0, 19).replaceFirst('T', ' ');
  }
}
