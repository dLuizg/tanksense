import '../models/database_connection.dart';
import '../models/entidade_base.dart';

abstract class BaseDAO<T extends EntidadeBase> {
  final DatabaseConnection db;
  final String tableName;
  final String idColumn; // Nome da coluna ID no DB (Ex: 'idEmpresa')

  BaseDAO(this.db, this.tableName, this.idColumn);

  T fromMap(Map<String, dynamic> map); // Método Factory de Entidade

  Future<int> insert(T entity);

  Future<List<T>> fetchAll() async {
    final result = await db.query('SELECT * FROM $tableName');
    return result.map((map) => fromMap(map)).toList();
  }

  // ... métodos de findById, update, delete
}
