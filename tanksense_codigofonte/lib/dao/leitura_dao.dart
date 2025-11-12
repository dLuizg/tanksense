// lib/dao/leitura_dao.dart
import '../models/database_connection.dart';
import '../models/leitura.dart';

// Classe responsável pelas operações de banco da entidade Leitura
// POO: Responsabilidade Única — gerencia apenas as leituras
class LeituraDao {
  // Conexão injetada — favorece o desacoplamento e a testabilidade
  final DatabaseConnection db;
  LeituraDao(this.db);

  // Busca todas as leituras armazenadas, ordenadas por timestamp (mais recentes primeiro)
  // LÓGICA: transforma os resultados SQL em objetos Leitura
  Future<List<Leitura>> fetchAll() async {
    final leituras = <Leitura>[];
    try {
      final resultados = await db.connection!.query('''
        SELECT idLeitura, timestamp, distanciaCm, nivelCm, porcentagem, statusTanque 
        FROM leitura 
        ORDER BY timestamp DESC
      ''');

      // Percorre os registros retornados e converte cada linha em um objeto Leitura
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

  // Insere várias leituras de uma vez associadas a um sensor específico
  // LÓGICA: percorre a lista e insere cada leitura individualmente, contabilizando as bem-sucedidas
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

  // Converte objeto DateTime para o formato aceito pelo MySQL (YYYY-MM-DD HH:MM:SS)
  // POO: Encapsulamento — método privado, usado apenas dentro da classe
  String _formatarDataParaMySQL(DateTime dateTime) {
    return dateTime.toIso8601String().substring(0, 19).replaceFirst('T', ' ');
  }
}
