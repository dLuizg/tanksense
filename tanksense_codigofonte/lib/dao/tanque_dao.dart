// lib/dao/tanque_dao.dart
import '../database_connection.dart';
import '../tanque.dart';

class TanqueDao {
  final DatabaseConnection db;
  TanqueDao(this.db);

  Future<List<Tanque>> fetchAll() async {
    final tanques = <Tanque>[];
    try {
      var resultados = await db.connection!.query('SELECT * FROM tanque');
      for (var row in resultados) {
        // RECOMENDAÇÃO: Mude isso para row.fields['nome_coluna']
        // Usar row.toList()[index] é muito frágil e quebra se a
        // ordem das colunas no banco mudar.
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

  // --- INÍCIO DA MODIFICAÇÃO ---

  /// Insere um tanque no banco e retorna o objeto salvo com o ID.
  Future<Tanque?> insert(Tanque tanque, int localId, int dispositivoId) async {
    try {
      // 1. Executamos a query e guardamos o resultado
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

      // 2. Verificamos se a inserção deu certo (gerou um ID)
      final int? newId = resultado.insertId;

      if (newId != null && newId > 0) {
        // 3. Retornamos um NOVO objeto Tanque com o ID correto.
        return Tanque(
          newId,
          tanque.altura,
          tanque.volumeMax,
          tanque.volumeAtual,
        );
      }
      return null; // Falha na inserção
    } catch (e) {
      print('❌ Erro ao salvar tanque: $e');
      rethrow; // Propaga o erro para a camada de serviço
    }
  }
  // --- FIM DA MODIFICAÇÃO ---
}
