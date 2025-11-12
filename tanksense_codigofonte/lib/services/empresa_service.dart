import '../models/empresa.dart';
import '../models/database_connection.dart';
import '../dao/empresa_dao.dart';

// Classe de serviço para Empresa
class EmpresaService {
  // Variável para acessar os métodos do banco (DAO)
  final EmpresaDao _dao;
  // Construtores para inicializar o DAO
  EmpresaService(DatabaseConnection db) : _dao = EmpresaDao(db);
  EmpresaService.fromDao(this._dao);

// Busca todos os registros de empresas no banco
  Future<List<Empresa>> listarTodos() async {
    return await _dao.fetchAll();
  }

// Método 'listar' que reutiliza 'listarTodos'
  Future<List<Empresa>> listar() async {
    return await listarTodos();
  }

// Método para salvar uma empresa
  Future<Empresa> cadastrar(Empresa empresa) async {
    // Validação de campos obrigatórios
    if (empresa.nome.trim().isEmpty || empresa.cnpj.trim().isEmpty) {
      throw ArgumentError('Nome e CNPJ são obrigatórios');
    }
     // Insere no banco e obtém o ID
    final id = await _dao.insert(empresa);
    // Retorna o objeto completo com o ID
    return Empresa(id, empresa.nome, empresa.cnpj);
  }

// Método auxiliar para criar uma empresa
  Future<Empresa> criar(String nome) async {
    // Cria uma instância com dados padrão
    final empresa = Empresa(0, nome, '00000000000000'); // CNPJ placeholder
    // Chama o método 'cadastrar' para salvar
    return await cadastrar(empresa);
  }
}
