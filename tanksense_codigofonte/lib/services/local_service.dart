import '../local.dart';
import '../database_connection.dart';
import '../dao/local_dao.dart';

class LocalService {
  final LocalDao _dao;
  LocalService(DatabaseConnection db) : _dao = LocalDao(db);
  LocalService.fromDao(this._dao);

  Future<List<Local>> listarTodos() async {
    return await _dao.fetchAll();
  }

  Future<List<Local>> listar() async {
    return await listarTodos();
  }

  Future<Local> cadastrar(Local local) async {
    if (local.nome.trim().isEmpty || local.referencia.trim().isEmpty) {
      throw ArgumentError('Nome e referência são obrigatórios');
    }
    final id = await _dao.insert(local); // <-- O erro acontece aqui
    return Local(id, local.nome, local.referencia, local.empresaId);
  }

  Future<Local> criar(String nome) async {
    final local =
        Local(0, nome, 'Referência padrão', 1); // empresaId placeholder
    return await cadastrar(local);
  }
}
