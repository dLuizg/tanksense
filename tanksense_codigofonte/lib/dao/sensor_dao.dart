// lib/dao/sensor_dao.dart
import '../database_connection.dart';
import '../sensor.dart';

class SensorDao {
  final DatabaseConnection db;
  SensorDao(this.db);

  Future<List<Sensor>> fetchAll() async {
    final sensores = <Sensor>[];
    try {
      var resultados = await db.connection!.query('SELECT * FROM sensor');
      for (var row in resultados) {
        // RECOMENDAÇÃO: Mude isso para row.fields['nome_coluna']
        // Usar row.toList()[index] é muito frágil.
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

  // --- INÍCIO DA MODIFICAÇÃO ---

  /// Insere um sensor no banco e retorna o objeto salvo com o ID.
  Future<Sensor?> insert(Sensor sensor) async {
    try {
      // 1. Executamos a query e guardamos o resultado
      var resultado = await db.connection!.query(
        'INSERT INTO sensor (tipo, unidadeMedida, dispositivo_idDispositivo) VALUES (?, ?, ?)',
        [sensor.tipo, sensor.unidadeMedida, sensor.dispositivoId],
      );

      // 2. Verificamos se a inserção deu certo (gerou um ID)
      final int? newId = resultado.insertId;

      if (newId != null && newId > 0) {
        // 3. Retornamos um NOVO objeto Sensor com o ID correto.
        return Sensor(
          newId,
          sensor.tipo,
          sensor.unidadeMedida,
          sensor.dispositivoId,
        );
      }
      return null; // Falha na inserção
    } catch (e) {
      print('❌ Erro ao salvar sensor: $e');
      rethrow; // Propaga o erro para a camada de serviço
    }
  }
  // --- FIM DA MODIFICAÇÃO ---
}
