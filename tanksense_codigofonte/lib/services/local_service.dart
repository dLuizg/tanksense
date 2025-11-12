import '../models/local.dart';
import '../models/database_connection.dart';
import '../dao/local_dao.dart';

// Serviço responsável pela regra de negócio e validação da entidade "Local".
// Ele faz a ponte entre a camada de dados (DAO) e o restante da aplicação.
class LocalService {
  final LocalDao _dao;
  // Construtor padrão: cria o DAO com base em uma conexão de banco de dados
  LocalService(DatabaseConnection db) : _dao = LocalDao(db);
  
  // Construtor alternativo que recebe um DAO já existente (útil para testes)
  LocalService.fromDao(this._dao);

 
  // Construtor alternativo que recebe um DAO já existente (útil para testes)
  Future<List<Local>> listarTodos() async {
    return await _dao.fetchAll();
  }
 // Método que chama listarTodos (mantido por compatibilidade ou clareza)
  Future<List<Local>> listar() async {
    return await listarTodos();
  }

 // Cadastra um novo local no banco, realizando validações antes do insert 
  Future<Local> cadastrar(Local local) async {
    if (local.nome.trim().isEmpty || local.referencia.trim().isEmpty) {
      throw ArgumentError('Nome e referência são obrigatórios');
    }
    final id = await _dao.insert(local); // <-- O erro acontece aqui
    return Local(id, local.nome, local.referencia, local.empresaId);
  }

 // Cria um novo Local com valores padrão (exemplo de atalho para cadastro rápido)
  Future<Local> criar(String nome) async {
    final local =
        Local(0, nome, 'Referência padrão', 1); // empresaId placeholder
    return await cadastrar(local);
  }
}
