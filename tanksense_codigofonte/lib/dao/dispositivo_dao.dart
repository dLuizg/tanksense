// lib/dao/dispositivo_dao.dart
import '../database_connection.dart';
import '../dispositivo.dart';

class DispositivoDao {
  final DatabaseConnection db;
  DispositivoDao(this.db);

  Future<List<Dispositivo>> fetchAll() async {
    final dispositivos = <Dispositivo>[];
    try {
      var resultados = await db.connection!.query('SELECT * FROM dispositivo');
      for (var row in resultados) {
        // RECOMENDAÇÃO: Mude isso para row.fields['nome_coluna']
        // Usar row.toList()[index] é muito frágil.
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

  // --- INÍCIO DA MODIFICAÇÃO ---

  /// Insere um dispositivo no banco e retorna o objeto salvo com o ID.
  Future<Dispositivo?> insert(Dispositivo dispositivo) async {
    try {
      // 1. Executamos a query e guardamos o resultado
      var resultado = await db.connection!.query(
        'INSERT INTO dispositivo (modelo, status) VALUES (?, ?)',
        [dispositivo.modelo, dispositivo.status],
      );

      // 2. Verificamos se a inserção deu certo (gerou um ID)
      final int? newId = resultado.insertId;

      if (newId != null && newId > 0) {
        // 3. Retornamos um NOVO objeto Dispositivo com o ID correto.
        return Dispositivo(
          newId,
          dispositivo.modelo,
          dispositivo.status,
        );
      }
      return null; // Falha na inserção
    } catch (e) {
      print('❌ Erro ao salvar dispositivo: $e');
      rethrow; // Propaga o erro para a camada de serviço
    }
  }
  // --- FIM DA MODIFICAÇÃO ---
}
