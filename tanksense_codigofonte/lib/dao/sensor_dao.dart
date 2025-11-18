// lib/dao/sensor_dao.dart
// Classe responsável por realizar operações de acesso a dados (DAO) da entidade Sensor.
// Contém métodos para buscar e inserir sensores no banco de dados MySQL.

import '../models/database/database_connection.dart';
import '../models/sensor.dart';

class SensorDao {
  // Instância da conexão com o banco de dados
  final DatabaseConnection db;

  // Construtor que recebe a conexão e a associa à DAO
  SensorDao(this.db);

  // Método responsável por buscar todos os sensores cadastrados no banco
  Future<List<Sensor>> fetchAll() async {
    // Lista que armazenará os sensores recuperados
    final sensores = <Sensor>[];

    try {
      // Executa a consulta SQL para obter todos os sensores da tabela
      var resultados = await db.connection!.query('SELECT * FROM sensor');

      // Percorre cada linha retornada pela consulta
      for (var row in resultados) {
        // Converte o resultado para lista para facilitar o acesso por índice
        var dados = row.toList();

        // Garante que há ao menos 3 colunas esperadas: id, tipo e unidade
        if (dados.length >= 3) {
          // Converte o primeiro valor (id) para inteiro
          final id = (dados[0] as num).toInt();

          // Segundo valor corresponde ao tipo do sensor (ex: temperatura, corrente, etc)
          final tipo = dados[1].toString();

          // Terceiro valor representa a unidade de medida (ex: °C, A, V, etc)
          final unidade = dados[2].toString();

          // O quarto valor, caso exista, representa o id do dispositivo associado
          final dispositivoId =
              dados.length >= 4 ? (dados[3] as num).toInt() : 0;

          // Cria um objeto Sensor a partir dos dados lidos e adiciona à lista
          sensores.add(Sensor(id, tipo, unidade, dispositivoId));
        }
      }
    } catch (e) {
      // Caso ocorra algum erro de conexão ou consulta, ele será tratado aqui
      print('❌ Erro ao carregar sensores: $e');
    }

    // Retorna a lista de sensores obtidos
    return sensores;
  }

  // Método responsável por inserir um novo sensor na tabela do banco
  Future<Sensor?> insert(Sensor sensor) async {
    try {
      // Executa a instrução SQL de inserção com os valores do sensor recebido
      var resultado = await db.connection!.query(
        'INSERT INTO sensor (tipo, unidadeMedida, dispositivo_idDispositivo) VALUES (?, ?, ?)',
        [sensor.tipo, sensor.unidadeMedida, sensor.dispositivoId],
      );

      // Obtém o ID gerado automaticamente pelo banco após a inserção
      final int? newId = resultado.insertId;

      // Caso o ID seja válido, retorna o objeto Sensor com o novo ID atribuído
      if (newId != null && newId > 0) {
        return Sensor(
          newId,
          sensor.tipo,
          sensor.unidadeMedida,
          sensor.dispositivoId,
        );
      }

      // Se algo falhar na inserção, retorna null
      return null;
    } catch (e) {
      // Captura e exibe qualquer erro que ocorra durante a inserção
      print('❌ Erro ao salvar sensor: $e');
      rethrow; // Relança o erro para permitir tratamento em outro nível
    }
  }
}
