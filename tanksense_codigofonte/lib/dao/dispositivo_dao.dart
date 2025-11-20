// lib/dao/dispositivo_dao.dart

import 'database/database_connection.dart';
import '../models/dispositivo.dart';

// Classe responsável pelas operações de banco referentes à entidade Dispositivo
// POO: Aplica o princípio da responsabilidade única (SRP) — lida apenas com dispositivos
class DispositivoDao {
  // Conexão injetada — Injeção de Dependência promove desacoplamento
  final DatabaseConnection db;

  DispositivoDao(this.db);

  // Busca todos os registros de dispositivos no banco
  // LÓGICA: converte cada linha do banco em um objeto Dispositivo
  Future<List<Dispositivo>> fetchAll() async {
    final dispositivos = <Dispositivo>[];
    try {
      var resultados = await db.connection!.query('SELECT * FROM dispositivo');
      for (var row in resultados) {
        var dados = row.toList();
        if (dados.length >= 3) {
          dispositivos.add(Dispositivo((dados[0] as num).toInt(),
              dados[1].toString(), dados[2].toString()));
        }
      }
    } catch (e) {
      print('❌ Erro ao carregar dispositivos: $e');
    }
    return dispositivos;
  }

  // Insere um novo dispositivo e retorna o objeto com o ID gerado
  // POO: Encapsulamento — lógica de escrita isolada dentro da classe DAO
  Future<Dispositivo?> insert(Dispositivo dispositivo) async {
    try {
      var resultado = await db.connection!.query(
        'INSERT INTO dispositivo (modelo, status) VALUES (?, ?)',
        [dispositivo.modelo, dispositivo.status],
      );

      final int? newId = resultado.insertId;

      if (newId != null && newId > 0) {
        return Dispositivo(
          newId,
          dispositivo.modelo,
          dispositivo.status,
        );
      }
      return null;
    } catch (e) {
      print('❌ Erro ao salvar dispositivo: $e');
      rethrow;
    }
  }
}
