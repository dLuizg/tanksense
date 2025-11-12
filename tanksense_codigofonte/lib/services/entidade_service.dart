// services/entidade_service.dart
import '../models/database_connection.dart';
import '../models/entidade_base.dart';
import '../models/empresa.dart';
import '../models/local.dart';
import '../models/dispositivo.dart';
import '../models/sensor.dart';
import '../models/tanque.dart';
import '../models/usuario.dart';
import '../models/leitura.dart';
import '../models/producao.dart';

// Classe genérica base para serviços de entidades
// Fornece métodos padrão como cadastrar, listar e gerar IDs automáticos.
class _BaseService<T extends EntidadeBase> {
  final DatabaseConnection db;
  final List<T> localList;
  final T Function(Map<String, dynamic>) mapper;
  int _nextId = 1;

  _BaseService(this.db, this.localList, this.mapper);

 //Método genérico para cadastrar uma entidade (simula operação no banco)
  Future<void> cadastrar(T entidade, String sql) async {
    localList.add(entidade);
    // Simula a escrita no banco
    await db.execute(sql, [/* params de entidade */]);
  }

// Simula a leitura de registros no banco e converte os resultados em objetos T
  Future<List<T>> listar() async {
    // Simula a leitura do banco
    final results = await db.query('SELECT * FROM alguma_tabela');
    // Mapeamento real: converte os resultados do banco para objetos T
    return results.map((row) => mapper(row)).toList();
  }

// Retorna o próximo ID disponível com base nos registros locais
  int getNextId() {
    if (localList.isNotEmpty) {
      _nextId = localList.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
    }
    return _nextId++;
  }
}

// Serviço específico para a entidade Empresa
class EmpresaService extends _BaseService<Empresa> {
  EmpresaService(DatabaseConnection db, List<Empresa> list)
      : super(db, list, Empresa.fromMap);
  Future<void> cadastrarEmpresa(Empresa empresa) async =>
      super.cadastrar(empresa, 'INSERT INTO empresa (...) VALUES (...)');
}

// Serviço para a entidade Local
class LocalService extends _BaseService<Local> {
  LocalService(DatabaseConnection db, List<Local> list)
      : super(db, list, Local.fromMap);
  Future<void> cadastrarLocal(Local local, int empresaId) async => super
      .cadastrar(local, 'INSERT INTO local (...) VALUES (..., $empresaId)');
}

// Serviço para Dispositivo
class DispositivoService extends _BaseService<Dispositivo> {
  DispositivoService(DatabaseConnection db, List<Dispositivo> list)
      : super(
            db,
            list,
            (map) => Dispositivo(map['idDispositivo'] as int,
                map['modelo'] as String, map['status'] as String));
  Future<void> cadastrarDispositivo(Dispositivo dispositivo) async => super
      .cadastrar(dispositivo, 'INSERT INTO dispositivo (...) VALUES (...)');
}

// Serviço para Sensor
class SensorService extends _BaseService<Sensor> {
  SensorService(DatabaseConnection db, List<Sensor> list)
      : super(
            db,
            list,
            (map) => Sensor(map['idSensor'] as int, map['tipo'] as String,
                map['unidadeMedida'] as String, map['dispositivoId'] as int));
  Future<void> cadastrarSensor(Sensor sensor) async =>
      super.cadastrar(sensor, 'INSERT INTO sensor (...) VALUES (...)');
}

// Serviço para Tanque
class TanqueService extends _BaseService<Tanque> {
  TanqueService(DatabaseConnection db, List<Tanque> list)
      : super(
            db,
            list,
            (map) => Tanque(
                map['idTanque'] as int,
                (map['altura'] as num).toDouble(),
                (map['volumeMax'] as num).toDouble(),
                (map['volumeAtual'] as num).toDouble()));
  Future<void> cadastrarTanque(
          Tanque tanque, int localId, int dispositivoId) async =>
      super.cadastrar(tanque,
          'INSERT INTO tanques (...) VALUES (..., $localId, $dispositivoId)');
}

// Serviço para Usuário
class UsuarioService extends _BaseService<Usuario> {
  UsuarioService(DatabaseConnection db, List<Usuario> list)
      : super(
            db,
            list,
            (map) => Usuario(
                map['idUsuario'] as int,
                map['nome'] as String,
                map['email'] as String,
                map['senhaLogin'] as String,
                map['perfil'] as String,
                DateTime.parse(map['dataCriacao'] as String),
                DateTime.parse(map['ultimoLogin'] as String),
                map['empresa_idEmpresa'] as int));
  Future<void> cadastrarUsuario(Usuario usuario) async =>
      super.cadastrar(usuario, 'INSERT INTO usuarios (...) VALUES (...)');
}

// Serviço responsável pelas leituras dos sensores
class LeituraService {
  final DatabaseConnection db;
  final List<Leitura> leiturasLocais;

  LeituraService(this.db, this.leiturasLocais);

   // Gera simuladas (mock) com dados fictícios e timestamps decrescentes
  Future<List<Leitura>> carregarDoFirebase(
      String baseUrl, String authToken) async {
    // MOCK: Gera 20 leituras fictícias.
    final List<Leitura> novasLeituras = [];
    final now = DateTime.now();
    for (int i = 0; i < 20; i++) {
      final timestamp = now.subtract(Duration(minutes: i * 5));
      final nivel = 100.0 - (i * 2.5); // Nível decrescente
      novasLeituras.add(Leitura(i + 1, timestamp, nivel, nivel, nivel,
          nivel > 50 ? 'OK' : 'Baixo', 'cm'));
    }
    return novasLeituras;
  }

// Simula a leitura das leituras já salvas no banco
  Future<List<Leitura>> listarBanco() async {
    // Simula buscar leituras já salvas no MySQL
    return []; // Retorna lista vazia para simular que não há nenhuma
  }


  // Envia novas leituras simuladas para o banco e adiciona na lista loca
  Future<void> enviarNovasParaBanco(
      List<Leitura> novasLeituras, int sensorId) async {
    for (var leitura in novasLeituras) {
      await db.execute(
          'INSERT INTO leitura (nivel, percent, status, timestamp, sensor_id) VALUES (?, ?, ?, ?, ?)',
          [
            leitura.nivelCm,
            leitura.porcentagem,
            leitura.status,
            leitura.timestampString,
            sensorId
          ]);
      leiturasLocais.add(leitura); // Adiciona na lista local após o "envio"
    }
    print('✅ ${novasLeituras.length} leituras salvas no MySQL/Local.');
  }
}

// Serviço responsável por calcular e registrar produções com base nas leituras
class ProducaoService {
  final DatabaseConnection db;
  final List<Producao> producoesLocais;
  int _nextId = 1;

  ProducaoService(this.db, this.producoesLocais);

// Calcula produções a partir das diferenças de nível entre leituras consecutivas
  List<Producao> calcularDeLeituras(List<Leitura> leituras) {
    if (leituras.length < 2) return [];

    final producoesGeradas = <Producao>[];
    final leiturasOrdenadas = leituras.reversed.toList();

    for (int i = 0; i < leiturasOrdenadas.length - 1; i++) {
      final leituraAnterior = leiturasOrdenadas[i];
      final leituraAtual = leiturasOrdenadas[i + 1];

      final diferencaNivel = leituraAnterior.nivelCm - leituraAtual.nivelCm;

      if (diferencaNivel > 0.01) {
        // --- INÍCIO DA CORREÇÃO (LINHA 183) ---
        producoesGeradas.add(Producao(
            _nextId++,
            1, // sensorId (mock)
            leituraAtual.timestamp,
            diferencaNivel,
            'Produção',
            '' // <-- 6º ARGUMENTO 'detalhes' (ESTAVA FALTANDO)
            ));
        // --- FIM DA CORREÇÃO ---
      }
    }

    return producoesGeradas;
  }

// Envia as produções calculadas para o banco
  Future<void> enviarParaBanco(List<Producao> producoes, int sensorId) async {
    for (var producao in producoes) {
      await db.execute(
          'INSERT INTO producao (quantidade, data, sensor_id) VALUES (?, ?, ?)',
          [producao.quantidade, producao.dataHora.toIso8601String(), sensorId]);
    }
    print('✅ ${producoes.length} produções salvas no MySQL.');
  }
}
