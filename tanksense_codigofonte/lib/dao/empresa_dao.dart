import 'base_dao.dart';
import '../database_connection.dart';
import '../empresa.dart';

class EmpresaDao extends BaseDAO<Empresa> {
  EmpresaDao(DatabaseConnection db) : super(db, 'empresa', 'idEmpresa');

  @override
  Empresa fromMap(Map<String, dynamic> map) {
    return Empresa.fromMap(map);
  }

  @override
  Future<int> insert(Empresa entity) async {
    try {
      // SQL com placeholders "?"
      final sql = 'INSERT INTO empresa (nome, cnpj) VALUES (?, ?)';

      // parâmetros na mesma ordem dos "?"
      final params = [entity.nome, entity.cnpj];

      // executa normalmente
      return await db.execute(sql, params);
    } catch (e) {
      print('❌ Erro ao salvar empresa: $e');
      rethrow;
    }
  }
}
