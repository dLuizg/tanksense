// lib/dao/local_dao.dart

import '../models/database_connection.dart';
import '../models/local.dart';
import 'base_dao.dart';

// DAO responsável pelas operações de banco da entidade Local
// POO: Herança — aproveita a estrutura genérica definida em BaseDAO
class LocalDao extends BaseDAO<Local> {
  // Construtor que define a tabela e a coluna de ID específicas da entidade Local
  LocalDao(DatabaseConnection db) : super(db, 'local', 'idLocal');

  // Converte um Map (registro do banco) em um objeto Local
  // POO: Polimorfismo — implementação específica do método abstrato da classe base
  @override
  Local fromMap(Map<String, dynamic> map) {
    return Local.fromMap(map);
  }

  // Insere um novo registro de Local no banco
  // LÓGICA: executa comando parametrizado, evitando SQL Injection
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
