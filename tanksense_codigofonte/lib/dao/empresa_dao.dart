import 'base_dao.dart';
import '../models/database_connection.dart';
import '../models/empresa.dart';

class EmpresaDao extends BaseDAO<Empresa> {
  EmpresaDao(DatabaseConnection db) : super(db, 'empresa', 'idEmpresa');

  @override
  Empresa fromMap(Map<String, dynamic> map) {
    return Empresa.fromMap(map);
  }

  @override
  Future<int> insert(Empresa entity) async {
    try {
      final sql = 'INSERT INTO empresa (nome, cnpj) VALUES (?, ?)';

      final params = [entity.nome, entity.cnpj];

      return await db.execute(sql, params);
    } catch (e) {
      print('❌ Erro ao salvar empresa: $e');
      rethrow;
    }
  }
}
