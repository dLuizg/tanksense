// lib/dao/tanque_dao.dart
import '../models/database_connection.dart';
import '../models/tanque.dart';

class TanqueDao {
  final DatabaseConnection db;
  TanqueDao(this.db);

  Future<List<Tanque>> fetchAll() async {
    final tanques = <Tanque>[];
    try {
      var resultados = await db.connection!.query('SELECT * FROM tanque');
      for (var row in resultados) {
        var dados = row.toList();
        if (dados.length >= 4) {
          tanques.add(Tanque(
            (dados[0] as num).toInt(),
            (dados[1] as num).toDouble(),
            (dados[2] as num).toDouble(),
            (dados[3] as num).toDouble(),
          ));
        }
      }
    } catch (e) {
      print('❌ Erro ao carregar tanques: $e');
    }
    return tanques;
  }

  Future<Tanque?> insert(Tanque tanque, int localId, int dispositivoId) async {
    try {
      var resultado = await db.connection!.query(
        'INSERT INTO tanque (altura, volumeMax, volumeAtual, local_idLocal, dispositivo_idDispositivo) VALUES (?, ?, ?, ?, ?)',
        [
          tanque.altura,
          tanque.volumeMax,
          tanque.volumeAtual,
          localId,
          dispositivoId
        ],
      );

      final int? newId = resultado.insertId;

      if (newId != null && newId > 0) {
        return Tanque(
          newId,
          tanque.altura,
          tanque.volumeMax,
          tanque.volumeAtual,
        );
      }
      return null;
    } catch (e) {
      print('❌ Erro ao salvar tanque: $e');
      rethrow;
    }
  }
}
