import 'package:mysql1/mysql1.dart';
import 'database_config.dart';
import 'empresa.dart';
import 'local.dart';
import 'tanque.dart';
import 'dispositivo.dart';
import 'sensor.dart';
import 'leitura.dart';
import 'usuario.dart';

class DatabaseConnection {
  final DatabaseConfig config;
  MySqlConnection? _connection;

  DatabaseConnection(this.config);

  Future<bool> connect() async {
    try {
      _connection = await MySqlConnection.connect(ConnectionSettings(
        host: config.host,
        port: config.porta,
        user: config.usuario,
        password: config.senha,
        db: config.dbName,
      ));

      // Testa a Conexao com um query simples
      try {
        await _connection!.query('SELECT 1');
        print('✅ Conexão estabelecida com Sucesso!');
        return true;
      } catch (queryError) {
        print('❌ Erro ao executar query de teste: $queryError');
        return false;
      }
    } catch (e) {
      print('❌ Erro ao conectar: $e');
      return false;
    }
  }

  Future<void> close() async {
    await _connection?.close();
    print('🔌 Conexão encerrada!');
  }

  Future<List<Map<String, dynamic>>> query(String sql,
      [List<Object?>? params]) async {
    if (_connection == null) throw Exception('Database not connected');
    final results = await _connection!.query(sql, params);
    return results.map((row) => row.fields).toList();
  }

  Future<int> execute(String sql, [List<Object?>? params]) async {
    if (_connection == null) throw Exception('Database not connected');
    final result = await _connection!.query(sql, params);
    return result.insertId ?? 0;
  }

  MySqlConnection? get connection => _connection;

  // ========== MÉTODOS PARA SALVAR ENTIDADES ==========

  Future<void> salvarEmpresa(Empresa empresa) async {
    await execute(
      'INSERT INTO empresa (nome, cnpj) VALUES (?, ?)',
      [empresa.nome, empresa.cnpj],
    );
  }

  Future<void> salvarLocal(Local local, int empresaId) async {
    await execute(
      'INSERT INTO local (nome, referencia, empresa_idEmpresa) VALUES (?, ?, ?)',
      [local.nome, local.referencia, empresaId],
    );
  }

  Future<void> salvarTanque(Tanque tanque, int localId) async {
    await execute(
      'INSERT INTO tanque (altura, volume_max, volume_atual, local_idLocal) VALUES (?, ?, ?, ?)',
      [tanque.altura, tanque.volumeMax, tanque.volumeAtual, localId],
    );
  }

  Future<void> salvarDispositivo(Dispositivo dispositivo, int localId) async {
    await execute(
      'INSERT INTO dispositivo (modelo, status, local_idLocal) VALUES (?, ?, ?)',
      [dispositivo.modelo, dispositivo.status, localId],
    );
  }

  Future<void> salvarSensor(Sensor sensor, int dispositivoId) async {
    await execute(
      'INSERT INTO sensor (tipo, unidade, dispositivo_idDispositivo) VALUES (?, ?, ?)',
      [sensor.tipo, sensor.unidadeMedida, dispositivoId],
    );
  }

  Future<void> salvarUsuario(Usuario usuario, int empresaId) async {
    await execute(
      'INSERT INTO usuario (nome, email, senha, perfil, empresa_idEmpresa) VALUES (?, ?, ?, ?, ?)',
      [
        usuario.nome,
        usuario.email,
        usuario.senhaLogin,
        usuario.perfil,
        empresaId
      ],
    );
  }

  Future<void> salvarLeitura(Leitura leitura) async {
    await execute(
      'INSERT INTO leitura (timestamp, distancia_cm, nivel_cm, porcentagem, status, sensor_idSensor) VALUES (?, ?, ?, ?, ?, ?)',
      [
        leitura.timestamp.toIso8601String(),
        leitura.distanciaCm,
        leitura.nivelCm,
        leitura.porcentagem,
        leitura.status,
        leitura.tanqueId
      ],
    );
  }

  // ========== MÉTODOS PARA BUSCAR ENTIDADES ==========

  Future<List<Leitura>> buscarLeituras() async {
    final results =
        await query('SELECT * FROM leitura ORDER BY timestamp DESC');
    return results.map((row) {
      return Leitura(
        row['idLeitura'] ?? 0,
        DateTime.parse(row['timestamp'].toString()),
        row['distancia_cm'] ?? 0.0,
        row['nivel_cm'] ?? 0.0,
        row['porcentagem'] ?? 0.0,
        row['status'] ?? '',
        'cm',
      );
    }).toList();
  }

  // ========== MÉTODOS PARA CRIAR TABELAS ==========

  Future<void> criarTabelasBase() async {
    // Criar tabela empresa
    await execute('''
      CREATE TABLE IF NOT EXISTS empresa (
        idEmpresa INT AUTO_INCREMENT PRIMARY KEY,
        nome VARCHAR(255) NOT NULL,
        cnpj VARCHAR(14) NOT NULL UNIQUE
      )
    ''');

    // Criar tabela local
    await execute('''
      CREATE TABLE IF NOT EXISTS local (
        idLocal INT AUTO_INCREMENT PRIMARY KEY,
        nome VARCHAR(255) NOT NULL,
        referencia VARCHAR(255) NOT NULL,
        empresa_idEmpresa INT NOT NULL,
        FOREIGN KEY (empresa_idEmpresa) REFERENCES empresa(idEmpresa) ON DELETE CASCADE
      )
    ''');

    // Criar tabela tanque
    await execute('''
      CREATE TABLE IF NOT EXISTS tanque (
        idTanque INT AUTO_INCREMENT PRIMARY KEY,
        altura DOUBLE NOT NULL,
        volume_max DOUBLE NOT NULL,
        volume_atual DOUBLE NOT NULL,
        local_idLocal INT NOT NULL,
        FOREIGN KEY (local_idLocal) REFERENCES local(idLocal) ON DELETE CASCADE
      )
    ''');

    // Criar tabela dispositivo
    await execute('''
      CREATE TABLE IF NOT EXISTS dispositivo (
        idDispositivo INT AUTO_INCREMENT PRIMARY KEY,
        modelo VARCHAR(255) NOT NULL,
        status VARCHAR(50) NOT NULL,
        local_idLocal INT NOT NULL,
        FOREIGN KEY (local_idLocal) REFERENCES local(idLocal) ON DELETE CASCADE
      )
    ''');

    // Criar tabela sensor
    await execute('''
      CREATE TABLE IF NOT EXISTS sensor (
        idSensor INT AUTO_INCREMENT PRIMARY KEY,
        tipo VARCHAR(100) NOT NULL,
        unidade VARCHAR(20) NOT NULL,
        dispositivo_idDispositivo INT NOT NULL,
        FOREIGN KEY (dispositivo_idDispositivo) REFERENCES dispositivo(idDispositivo) ON DELETE CASCADE
      )
    ''');

    // Criar tabela usuario
    await execute('''
      CREATE TABLE IF NOT EXISTS usuario (
        idUsuario INT AUTO_INCREMENT PRIMARY KEY,
        nome VARCHAR(255) NOT NULL,
        email VARCHAR(255) NOT NULL UNIQUE,
        senha VARCHAR(255) NOT NULL,
        perfil VARCHAR(50) NOT NULL,
        empresa_idEmpresa INT,
        FOREIGN KEY (empresa_idEmpresa) REFERENCES empresa(idEmpresa) ON DELETE SET NULL
      )
    ''');

    // Criar tabela leitura
    await execute('''
      CREATE TABLE IF NOT EXISTS leitura (
        idLeitura INT AUTO_INCREMENT PRIMARY KEY,
        timestamp DATETIME NOT NULL,
        distancia_cm DOUBLE NOT NULL,
        nivel_cm DOUBLE NOT NULL,
        porcentagem DOUBLE NOT NULL,
        status VARCHAR(20) NOT NULL,
        sensor_idSensor INT,
        FOREIGN KEY (sensor_idSensor) REFERENCES sensor(idSensor) ON DELETE SET NULL
      )
    ''');

    // Criar tabela producao
    await execute('''
      CREATE TABLE IF NOT EXISTS producao (
        idProducao INT AUTO_INCREMENT PRIMARY KEY,
        quantidade DOUBLE NOT NULL,
        data_producao DATETIME NOT NULL
      )
    ''');
  }
}
