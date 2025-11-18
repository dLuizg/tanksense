// lib/dao/empresa_dao.dart

import 'base_dao.dart';
import '../models/database/database_connection.dart';
import '../models/empresa.dart';

// DAO responsável pelas operações de banco da entidade Empresa
// POO: Herança — estende BaseDAO para reutilizar comportamentos genéricos
class EmpresaDao extends BaseDAO<Empresa> {
  // Chama o construtor da classe base com os parâmetros específicos da tabela empresa
  EmpresaDao(DatabaseConnection db) : super(db, 'empresa', 'idEmpresa');

  // Converte um Map (registro do banco) em um objeto Empresa
  // POO: Polimorfismo — implementação específica do método abstrato da classe base
  @override
  Empresa fromMap(Map<String, dynamic> map) {
    return Empresa.fromMap(map);
  }

  // Insere uma nova empresa no banco
  // LÓGICA: executa comando SQL com parâmetros protegidos para evitar SQL Injection
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
