import '../models/empresa.dart';
import '../models/database_connection.dart';
import '../dao/empresa_dao.dart';

class EmpresaService {
  final EmpresaDao _dao;
  EmpresaService(DatabaseConnection db) : _dao = EmpresaDao(db);
  EmpresaService.fromDao(this._dao);

  Future<List<Empresa>> listarTodos() async {
    return await _dao.fetchAll();
  }

  Future<List<Empresa>> listar() async {
    return await listarTodos();
  }

  Future<Empresa> cadastrar(Empresa empresa) async {
    if (empresa.nome.trim().isEmpty || empresa.cnpj.trim().isEmpty) {
      throw ArgumentError('Nome e CNPJ são obrigatórios');
    }
    final id = await _dao.insert(empresa);
    return Empresa(id, empresa.nome, empresa.cnpj);
  }

  Future<Empresa> criar(String nome) async {
    final empresa = Empresa(0, nome, '00000000000000'); // CNPJ placeholder
    return await cadastrar(empresa);
  }
}
