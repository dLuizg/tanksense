import '../database_connection.dart';
import '../local.dart';
import 'base_dao.dart';

class LocalDao extends BaseDAO<Local> {
  LocalDao(DatabaseConnection db) : super(db, 'local', 'idLocal');

  @override
  Local fromMap(Map<String, dynamic> map) {
    return Local.fromMap(map);
  }

  @override
  Future<int> insert(Local entity) async {
    try {
      return await db.execute(
        'INSERT INTO local (nome, referencia, empresa_idEmpresa) VALUES (?, ?, ?)',
        [entity.nome, entity.referencia, entity.empresaId],
      );
    } catch (e) {
      print('❌ Erro ao salvar local: $e');
      rethrow;
    }
  }

  
}
