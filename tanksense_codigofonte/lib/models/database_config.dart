// lib/database/database_config.dart

// POO: Classe para representar a configuração de conexão com o banco de dados
// Define o modelo de dados para as configurações necessárias
class DatabaseConfig {
  // POO: Atributos finais - imutáveis após a inicialização
  final String host;
  final int porta;
  final String usuario;
  final String senha;
  final String dbName;

  // POO: Construtor com parâmetros nomeados e obrigatórios
  // Garante que todos os dados necessários sejam fornecidos na criação do objeto
  DatabaseConfig({
    required this.host,
    required this.porta,
    required this.usuario,
    required this.senha,
    required this.dbName,
  });

  // POO: Método de instância que exibe as configurações de forma formatada
  // LÓGICA: Mostra os dados mas mascara a senha para segurança
  void exibirConfig() {
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

// LÓGICA: Cria uma instância global de configuração para ser reutilizada
// POO: Instância concreta da classe DatabaseConfig com valores definidos
final DatabaseConfig databaseConfig = DatabaseConfig(
  host: 'localhost',
  porta: 3306,
  usuario: 'root',
  senha: '296q',
  dbName: 'tanksense',
);