// lib/database_setup.dart
import 'database_connection.dart';

/// (POO) Esta classe segue o Princípio da Responsabilidade Única (SRP).
/// Sua única responsabilidade é configurar o schema (tabelas) do banco.
class DatabaseSetup {
  final DatabaseConnection _db;

  DatabaseSetup(this._db);

  /// Cria ou verifica todas as tabelas necessárias no banco.
  Future<void> criarTabelasBase() async {
    print('🔄 Verificando e criando tabelas (schema)...');

    // Criar tabela empresa
    await _db.execute('''
      CREATE TABLE IF NOT EXISTS empresa (
        idEmpresa INT AUTO_INCREMENT PRIMARY KEY,
        nome VARCHAR(255) NOT NULL,
        cnpj VARCHAR(14) NOT NULL UNIQUE
      )
    ''');

    // Criar tabela local
    await _db.execute('''
      CREATE TABLE IF NOT EXISTS local (
        idLocal INT AUTO_INCREMENT PRIMARY KEY,
        nome VARCHAR(255) NOT NULL,
        referencia VARCHAR(255) NOT NULL,
        empresa_idEmpresa INT NOT NULL,
        FOREIGN KEY (empresa_idEmpresa) REFERENCES empresa(idEmpresa) ON DELETE CASCADE
      )
    ''');

    // Criar tabela dispositivo
    await _db.execute('''
      CREATE TABLE IF NOT EXISTS dispositivo (
        idDispositivo INT AUTO_INCREMENT PRIMARY KEY,
        modelo VARCHAR(255) NOT NULL,
        status VARCHAR(50) NOT NULL
      )
    ''');

    // Criar tabela tanque
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

    // Criar tabela sensor
    await _db.execute('''
      CREATE TABLE IF NOT EXISTS sensor (
        idSensor INT AUTO_INCREMENT PRIMARY KEY,
        tipo VARCHAR(100) NOT NULL,
        unidadeMedida VARCHAR(20) NOT NULL,
        dispositivo_idDispositivo INT NOT NULL,
        FOREIGN KEY (dispositivo_idDispositivo) REFERENCES dispositivo(idDispositivo) ON DELETE CASCADE
      )
    ''');

    // Criar tabela usuario
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

    // Criar tabela leitura
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

    // Criar tabela producao
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
