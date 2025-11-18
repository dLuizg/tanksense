// lib/dao/producao_dao.dart
import '../models/database/database_connection.dart';
import '../models/producao.dart';
import 'base_dao.dart';

// DAO responsável pelas operações de banco da entidade Producao
// POO: Herança — reutiliza estrutura genérica e métodos da BaseDAO
class ProducaoDao extends BaseDAO<Producao> {
  // Define a tabela e o identificador da entidade Producao
  ProducaoDao(DatabaseConnection db) : super(db, 'producao', 'idProducao');

  // Converte um Map (registro do banco) em um objeto Producao
  // POO: Polimorfismo — implementação específica do método abstrato da classe base
  @override
  Producao fromMap(Map<String, dynamic> map) {
    return Producao.fromMap(map);
  }

  // Insere um registro de produção no banco
  // LÓGICA: prepara instrução SQL e parâmetros para execução segura
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

  // Insere várias produções de uma vez, vinculadas a um sensor específico
  // LÓGICA: realiza múltiplas inserções sequenciais (idealmente seria uma transação única)
  Future<int> insertMany(List<Producao> producoes, int sensorId) async {
    int linhasAfetadas = 0;
    for (final producao in producoes) {
      try {
        final id = await insert(producao.copyWith(sensorId: sensorId));
        if (id > 0) {
          linhasAfetadas++;
        }
      } catch (e) {
        print('❌ ${producao.dataHora}: $e');
      }
    }
    return linhasAfetadas;
  }

  // Busca produções dentro de um intervalo de tempo específico
  // LÓGICA: utiliza cláusula BETWEEN para filtrar registros por data
  Future<List<Producao>> fetchByPeriod(DateTime inicio, DateTime fim) async {
    final sql = 'SELECT * FROM producao WHERE timestamp BETWEEN ? AND ?';
    final params = [
      _formatarDataParaMySQL(inicio),
      _formatarDataParaMySQL(fim)
    ];
    final result = await db.query(sql, params);
    return result.map((map) => fromMap(map)).toList();
  }

  // Formata objeto DateTime para padrão aceito pelo MySQL (YYYY-MM-DD HH:MM:SS)
  // POO: Encapsulamento — método privado usado apenas internamente
  String _formatarDataParaMySQL(DateTime dateTime) {
    return dateTime.toIso8601String().substring(0, 19).replaceFirst('T', ' ');
  }
}
