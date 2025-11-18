// lib/dao/tanque_dao.dart
// Classe responsável por realizar as operações de acesso a dados (DAO) da entidade Tanque.
// Essa classe gerencia a leitura e gravação de dados da tabela 'tanque' no banco MySQL.

import '../models/database/database_connection.dart';
import '../models/tanque.dart';

class TanqueDao {
  // Instância de conexão com o banco de dados
  final DatabaseConnection db;

  // Construtor que recebe a instância do banco e associa à DAO
  TanqueDao(this.db);

  // Método responsável por buscar todos os tanques cadastrados no banco de dados
  Future<List<Tanque>> fetchAll() async {
    // Lista que armazenará todos os objetos Tanque obtidos da consulta
    final tanques = <Tanque>[];

    try {
      // Executa a consulta SQL que retorna todas as linhas da tabela 'tanque'
      var resultados = await db.connection!.query('SELECT * FROM tanque');

      // Percorre cada linha retornada pelo banco
      for (var row in resultados) {
        // Converte os dados da linha para uma lista genérica
        var dados = row.toList();

        // Verifica se existem pelo menos 4 colunas esperadas (id, altura, volumeMax, volumeAtual)
        if (dados.length >= 4) {
          // Cria um objeto Tanque com os dados convertidos e adiciona à lista
          tanques.add(Tanque(
            (dados[0] as num).toInt(),     // idTanque
            (dados[1] as num).toDouble(),  // altura
            (dados[2] as num).toDouble(),  // volume máximo
            (dados[3] as num).toDouble(),  // volume atual
          ));
        }
      }
    } catch (e) {
      // Captura e exibe um erro caso a consulta falhe
      print('❌ Erro ao carregar tanques: $e');
    }

    // Retorna a lista de tanques encontrados
    return tanques;
  }

  // Método responsável por inserir um novo tanque no banco de dados
  // Recebe o objeto Tanque e os IDs de Local e Dispositivo aos quais o tanque está associado
  Future<Tanque?> insert(Tanque tanque, int localId, int dispositivoId) async {
    try {
      // Executa o comando SQL de inserção com os parâmetros necessários
      var resultado = await db.connection!.query(
        'INSERT INTO tanque (altura, volumeMax, volumeAtual, local_idLocal, dispositivo_idDispositivo) VALUES (?, ?, ?, ?, ?)',
        [
          tanque.altura,       // Altura total do tanque
          tanque.volumeMax,    // Capacidade máxima em litros
          tanque.volumeAtual,  // Volume atual no momento do registro
          localId,             // Chave estrangeira para o local onde o tanque está instalado
          dispositivoId        // Chave estrangeira para o dispositivo vinculado ao tanque
        ],
      );

      // Obtém o ID gerado automaticamente pelo banco após a inserção
      final int? newId = resultado.insertId;

      // Se o ID for válido, retorna um novo objeto Tanque com o ID recém-criado
      if (newId != null && newId > 0) {
        return Tanque(
          newId,
          tanque.altura,
          tanque.volumeMax,
          tanque.volumeAtual,
        );
      }

      // Retorna null caso a inserção não tenha sido bem-sucedida
      return null;
    } catch (e) {
      // Captura e exibe qualquer erro ocorrido durante o processo de inserção
      print('❌ Erro ao salvar tanque: $e');
      rethrow; // Relança o erro para permitir tratamento em níveis superiores da aplicação
    }
  }
}
