// lib/models/database/database_setup.dart

// POO: Importando a definição da classe 'DatabaseConnection', da qual esta classe depende.
import 'database_connection.dart';

// POO: Definição da classe 'DatabaseSetup'.
// Esta classe encapsula toda a lógica de *criação* do esquema do banco.
// É um ótimo exemplo de Responsabilidade Única (Single Responsibility Principle - SRP).
class DatabaseSetup {
  // POO: Atributo (campo) privado e final.
  // Armazena a instância da conexão com o banco.
  final DatabaseConnection _db;

  // POO: Construtor da classe.
  // Ele recebe a conexão via Injeção de Dependência,
  // o que "compõe" a classe (ela "tem uma" conexão).
  DatabaseSetup(this._db);

  // POO: Definição de um método público da classe.
  // LÓGICA: É um método 'async' (assíncrono) pois a criação de tabelas
  // é uma operação de I/O (Entrada/Saída) que leva tempo.
  // Retorna 'Future<void>' (um futuro vazio), indicando que
  // apenas executa uma tarefa e não retorna um valor.
  Future<void> criarTabelasBase() async {
    // LÓGICA: Imprime um log no console (feedback para o usuário/dev).
    print('🔄 Verificando e criando tabelas (schema)...');

    // POO: Chama o método 'execute' no objeto '_db'.
    // LÓGICA: 'await' pausa a execução aqui até o comando SQL terminar.
    // LÓGICA: A String SQL ('CREATE TABLE IF NOT EXISTS') é a lógica de
    // definição da tabela 'empresa', especificando colunas (idEmpresa, nome, cnpj),
    // tipos (INT, VARCHAR), e restrições (AUTO_INCREMENT, PRIMARY KEY, NOT NULL, UNIQUE).
    await _db.execute('''
      CREATE TABLE IF NOT EXISTS empresa (
        idEmpresa INT AUTO_INCREMENT PRIMARY KEY,
        nome VARCHAR(255) NOT NULL,
        cnpj VARCHAR(14) NOT NULL UNIQUE
      )
    ''');

    // POO: Novamente, chama o método 'execute' no objeto '_db'.
    // LÓGICA: 'await' espera o comando terminar.
    // LÓGICA: Define a tabela 'local', criando um relacionamento 1:N com 'empresa'
    // através da 'FOREIGN KEY' (Chave Estrangeira).
    // LÓGICA: 'ON DELETE CASCADE' é uma regra que diz: se uma empresa for
    // deletada, todos os locais associados a ela também devem ser deletados.
    await _db.execute('''
      CREATE TABLE IF NOT EXISTS local (
        idLocal INT AUTO_INCREMENT PRIMARY KEY,
        nome VARCHAR(255) NOT NULL,
        referencia VARCHAR(255) NOT NULL,
        empresa_idEmpresa INT NOT NULL,
        FOREIGN KEY (empresa_idEmpresa) REFERENCES empresa(idEmpresa) ON DELETE CASCADE
      )
    ''');

    // POO: Chama o método 'execute' no objeto '_db'.
    // LÓGICA: Define a tabela 'dispositivo' (uma entidade independente).
    await _db.execute('''
      CREATE TABLE IF NOT EXISTS dispositivo (
        idDispositivo INT AUTO_INCREMENT PRIMARY KEY,
        modelo VARCHAR(255) NOT NULL,
        status VARCHAR(50) NOT NULL
      )
    ''');

    // POO: Chama o método 'execute' no objeto '_db'.
    // LÓGICA: Define a tabela 'tanque'.
    // LÓGICA: Esta tabela possui duas Chaves Estrangeiras,
    // relacionando-se tanto com 'local' quanto com 'dispositivo'.
    await _db.execute('''
      CREATE TABLE IF NOT EXISTS tanque (
        idTanque INT AUTO_INCREMENT PRIMARY KEY,
        altura DOUBLE NOT NULL,
        volumeMax DOUBLE NOT NULL,
        volumeAtual DOUBLE NOT NULL,
        local_idLocal INT NOT NULL,
        dispositivo_idDispositivo INT NOT NULL,
        FOREIGN KEY (local_idLocal) REFERENCES local(idLocal) ON DELETE CASCADE,
        FOREIGN KEY (dispositivo_idDispositivo) REFERENCES dispositivo(idDispositivo) ON DELETE CASCADE
      )
    ''');

    // POO: Chama o método 'execute' no objeto '_db'.
    // LÓGICA: Define a tabela 'sensor', que se relaciona com 'dispositivo' (1:N).
    await _db.execute('''
      CREATE TABLE IF NOT EXISTS sensor (
        idSensor INT AUTO_INCREMENT PRIMARY KEY,
        tipo VARCHAR(100) NOT NULL,
        unidadeMedida VARCHAR(20) NOT NULL,
        dispositivo_idDispositivo INT NOT NULL,
        FOREIGN KEY (dispositivo_idDispositivo) REFERENCES dispositivo(idDispositivo) ON DELETE CASCADE
      )
    ''');

    // POO: Chama o método 'execute' no objeto '_db'.
    // LÓGICA: Define a tabela 'usuario'.
    // LÓGICA: O relacionamento com 'empresa' é opcional (a coluna 'empresa_idEmpresa'
    // pode ser 'NULL').
    // LÓGICA: 'ON DELETE SET NULL' é uma regra que diz: se a empresa for deletada,
    // o campo 'empresa_idEmpresa' no usuário se tornará 'NULL', mas o usuário não
    // será deletado (diferente de 'CASCADE').
    await _db.execute('''
      CREATE TABLE IF NOT EXISTS usuario (
        idUsuario INT AUTO_INCREMENT PRIMARY KEY,
        nome VARCHAR(255) NOT NULL,
        email VARCHAR(255) NOT NULL UNIQUE,
        senhaLogin VARCHAR(255) NOT NULL,
        perfil VARCHAR(50) NOT NULL,
        dataCriacao DATETIME NOT NULL,
        ultimoLogin DATETIME NOT NULL,
        empresa_idEmpresa INT, 
        FOREIGN KEY (empresa_idEmpresa) REFERENCES empresa(idEmpresa) ON DELETE SET NULL
      )
    ''');

    // POO: Chama o método 'execute' no objeto '_db'.
    // LÓGICA: Define a tabela 'leitura' (tabela de "fatos", registra eventos).
    // LÓGICA: Relaciona-se com 'sensor'. O 'ON DELETE SET NULL' aqui garante
    // que, se um sensor for deletado, as leituras históricas não sejam
    // perdidas, apenas percam a referência ao sensor.
    await _db.execute('''
      CREATE TABLE IF NOT EXISTS leitura (
        idLeitura INT AUTO_INCREMENT PRIMARY KEY,
        timestamp DATETIME NOT NULL,
        distanciaCm DOUBLE NOT NULL,
        nivelCm DOUBLE NOT NULL,
        porcentagem DOUBLE NOT NULL,
        statusTanque VARCHAR(20) NOT NULL,
        sensor_idSensor INT,
        FOREIGN KEY (sensor_idSensor) REFERENCES sensor(idSensor) ON DELETE SET NULL
      )
    ''');

    // POO: Chama o método 'execute' no objeto '_db'.
    // LÓGICA: Define a tabela 'producao', outra tabela de "fatos".
    // LÓGICA: 'TEXT' é um tipo de dado para strings longas (detalhes).
    // LÓGICA: Aqui, 'ON DELETE CASCADE' é usado, significando que se o sensor
    // for deletado, os registros de produção associados a ele também são.
    await _db.execute('''
      CREATE TABLE IF NOT EXISTS producao (
        idProducao INT AUTO_INCREMENT PRIMARY KEY,
        quantidade DOUBLE NOT NULL,
        timestamp DATETIME NOT NULL,
        sensor_idSensor INT NOT NULL,
        tipoRegistro VARCHAR(50) NOT NULL,
        detalhes TEXT,
        FOREIGN KEY (sensor_idSensor) REFERENCES sensor(idSensor) ON DELETE CASCADE
      )
    ''');

    // LÓGICA: Imprime uma mensagem de sucesso no console.
    print('✅ Schema do banco verificado com sucesso.');
  }
} // POO: Fim da definição da classe 'DatabaseSetup'.
