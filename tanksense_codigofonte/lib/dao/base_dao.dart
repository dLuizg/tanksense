// lib/dao/base_dao.dart
import '../models/database/database_connection.dart';
import '../models/entidade_base.dart';

// Classe abstrata genérica que define o comportamento padrão de todos os DAOs.
// DAO (Data Access Object) é o padrão responsável pela comunicação com o banco de dados.
// Essa classe atua como uma “base” para todos os outros DAOs específicos do sistema.
abstract class BaseDAO<T extends EntidadeBase> {
  // POO: Encapsulamento — os atributos são mantidos internos à classe, acessados apenas por suas subclasses.

  // Conexão ativa com o banco de dados — usada para executar comandos SQL.
  final DatabaseConnection db;

  // Nome da tabela associada ao DAO específico (definido pela subclasse).
  final String tableName;

  // Nome da coluna que representa o identificador único (ID) da entidade.
  final String idColumn;

  // Construtor que injeta dependências fundamentais para o DAO funcionar.
  // POO: Injeção de Dependência — o DAO não cria sua própria conexão, ele recebe uma pronta,
  // promovendo desacoplamento e testabilidade.
  BaseDAO(this.db, this.tableName, this.idColumn);

  // Método abstrato que converte um Map (resultado do banco) em um objeto do tipo T.
  // POO: Abstração — a implementação exata será feita nas subclasses específicas de cada entidade.
  T fromMap(Map<String, dynamic> map);

  // Método abstrato que insere uma entidade no banco.
  // Cada DAO concreto definirá sua própria lógica de inserção.
  Future<int> insert(T entity);

  // Método padrão para buscar todos os registros de uma tabela.
  // LÓGICA: centraliza o comportamento de leitura genérica,
  // evitando duplicação de código entre os diversos DAOs.
  Future<List<T>> fetchAll() async {
    // Executa uma consulta SQL simples que retorna todos os registros da tabela.
    final result = await db.query('SELECT * FROM $tableName');

    // Converte cada linha do resultado em um objeto da entidade correspondente,
    // utilizando o método abstrato fromMap implementado na subclasse.
    return result.map((map) => fromMap(map)).toList();
  }
}
