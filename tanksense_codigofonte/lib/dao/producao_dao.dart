// lib/dao/producao_dao.dart
import '../models/database_connection.dart';
import '../models/producao.dart';
import 'base_dao.dart';

class ProducaoDao extends BaseDAO<Producao> {
  ProducaoDao(DatabaseConnection db) : super(db, 'producao', 'idProducao');

  @override
  Producao fromMap(Map<String, dynamic> map) {
    return Producao.fromMap(map);
  }

  @override
  Future<int> insert(Producao entity) async {
    final sql =
        'INSERT INTO producao (quantidade, timestamp, sensor_idSensor) VALUES (?, ?, ?)';
    final params = [
      entity.quantidade,
      _formatarDataParaMySQL(entity.dataHora),
      entity.sensorId
    ];
    return await db.execute(sql, params);
  }

  // --- INÍCIO DA MODIFICAÇÃO ---

  /// Insere múltiplas produções e retorna o número de linhas afetadas.
  Future<int> insertMany(List<Producao> producoes, int sensorId) async {
    int linhasAfetadas = 0;
    // (Idealmente, isso seria uma única transação)
    for (final producao in producoes) {
      try {
        // Usamos o 'insert' do BaseDAO que retorna o ID (ou linhas afetadas)
        final id = await insert(producao.copyWith(sensorId: sensorId));
        if (id > 0) {
          linhasAfetadas++;
        }
      } catch (e) {
        print('❌ ${producao.dataHora}: $e');
        // Continua para o próximo, mesmo se um falhar
      }
    }
    return linhasAfetadas;
  }
  // --- FIM DA MODIFICAÇÃO ---

  Future<List<Producao>> fetchByPeriod(DateTime inicio, DateTime fim) async {
    final sql = 'SELECT * FROM producao WHERE timestamp BETWEEN ? AND ?';
    final params = [
      _formatarDataParaMySQL(inicio),
      _formatarDataParaMySQL(fim)
    ];
    final result = await db.query(sql, params);
    return result.map((map) => fromMap(map)).toList();
  }

  String _formatarDataParaMySQL(DateTime dateTime) {
    // ... (sem mudanças)
    return dateTime.toIso8601String().substring(0, 19).replaceFirst('T', ' ');
  }
}
