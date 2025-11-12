// lib/database_setup.dart

import 'database_connection.dart';

// POO: Classe que aplica o Princípio da Responsabilidade Única (SRP)
// Sua única responsabilidade é gerenciar a criação do schema do banco de dados
class DatabaseSetup {
  final DatabaseConnection _db;

  // POO: Composição - recebe uma dependência de DatabaseConnection via construtor
  DatabaseSetup(this._db);

  // LÓGICA: Método principal que orquestra a criação de todas as tabelas
  // Garante que a estrutura do banco esteja pronta para uso
  Future<void> criarTabelasBase() async {
    print('🔄 Verificando e criando tabelas (schema)...');

    // LÓGICA: Criação da tabela empresa - entidade principal do sistema
    await _db.execute('''
      CREATE TABLE IF NOT EXISTS empresa (
        idEmpresa INT AUTO_INCREMENT PRIMARY KEY,
        nome VARCHAR(255) NOT NULL,
        cnpj VARCHAR(14) NOT NULL UNIQUE
      )
    ''');

    // LÓGICA: Tabela local com chave estrangeira para empresa
    // Relacionamento 1:N - uma empresa pode ter vários locais
    await _db.execute('''
      CREATE TABLE IF NOT EXISTS local (
        idLocal INT AUTO_INCREMENT PRIMARY KEY,
        nome VARCHAR(255) NOT NULL,
        referencia VARCHAR(255) NOT NULL,
        empresa_idEmpresa INT NOT NULL,
        FOREIGN KEY (empresa_idEmpresa) REFERENCES empresa(idEmpresa) ON DELETE CASCADE
      )
    ''');

    // LÓGICA: Tabela dispositivo - equipamentos independentes
    await _db.execute('''
      CREATE TABLE IF NOT EXISTS dispositivo (
        idDispositivo INT AUTO_INCREMENT PRIMARY KEY,
        modelo VARCHAR(255) NOT NULL,
        status VARCHAR(50) NOT NULL
      )
    ''');

    // LÓGICA: Tabela tanque com relacionamentos duplos
    // Conecta tanque a local e dispositivo simultaneamente
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

    // LÓGICA: Tabela sensor com chave estrangeira para dispositivo
    // Um dispositivo pode ter múltiplos sensores
    await _db.execute('''
      CREATE TABLE IF NOT EXISTS sensor (
        idSensor INT AUTO_INCREMENT PRIMARY KEY,
        tipo VARCHAR(100) NOT NULL,
        unidadeMedida VARCHAR(20) NOT NULL,
        dispositivo_idDispositivo INT NOT NULL,
        FOREIGN KEY (dispositivo_idDispositivo) REFERENCES dispositivo(idDispositivo) ON DELETE CASCADE
      )
    ''');

    // LÓGICA: Tabela usuario com dados de autenticação e perfil
    // Relacionamento opcional com empresa (pode ser nulo)
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

    // LÓGICA: Tabela leitura - registros de medições dos sensores
    // Armazena dados de nível e status do tanque
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

    // LÓGICA: Tabela producao - registros de produção com detalhes
    // Permite rastreamento completo das atividades
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

    print('✅ Schema do banco verificado com sucesso.');
  }
}