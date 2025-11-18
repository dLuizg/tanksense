// lib/models/database/database_config.dart

// POO: Definição da classe 'DatabaseConfig'.
// Esta classe serve como um "molde" (modelo de dados) para agrupar
// todas as informações necessárias para uma conexão de banco de dados.
class DatabaseConfig {
  // POO: Declaração de atributos (ou campos) da classe.
  // 'final' significa que, uma vez que um objeto DatabaseConfig é criado,
  // esses valores não podem ser alterados (imutabilidade).
  final String host;
  final int porta;
  final String usuario;
  final String senha;
  final String dbName;

  // POO: Construtor da classe.
  // LÓGICA: Usa parâmetros nomeados ('{...}') e a palavra-chave 'required'
  // para forçar que todos os atributos sejam fornecidos ao criar
  // uma nova instância (objeto) desta classe.
  DatabaseConfig({
    required this.host,
    required this.porta,
    required this.usuario,
    required this.senha,
    required this.dbName,
  });

  // POO: Definição de um método de instância.
  // Métodos são comportamentos/ações que o objeto pode realizar.
  // LÓGICA: 'void' indica que este método não retorna nenhum valor.
  void exibirConfig() {
    // LÓGICA: Imprime um texto formatado (String multi-linha com ''') no console.
    // LÓGICA: Usa interpolação de string ('$variavel') para exibir os valores.
    // LÓGICA: Aplica uma regra de segurança simples para mascarar a senha,
    // multiplicando o caractere '*' pelo tamanho (length) da string 'senha'.
    print('''
🔧 CONFIGURAÇÃO DO BANCO DE DADOS:
    📍 Host: $host
    🚪 Porta: $porta
    👤 Usuário: $usuario
    🔑 Senha: ${'*' * senha.length} 
    🗃️  Database: $dbName
''');
  }
}

// LÓGICA: Declaração de uma variável global e 'final'.
// 'final' aqui significa que a variável 'databaseConfig'
// sempre apontará para este *mesmo* objeto depois de inicializada.
// POO: Instanciação (criação) de um objeto concreto da classe 'DatabaseConfig'.
// Estamos usando o construtor definido acima para criar o objeto
// com valores literais (hardcoded).
final DatabaseConfig databaseConfig = DatabaseConfig(
  host: 'localhost',
  porta: 3306,
  usuario: 'root',
  senha: '@#Hrk15072006',
  dbName: 'tanksense',
);