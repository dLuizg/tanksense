// services/entidade_service.dart
import '../database_connection.dart';
import '../entidade_base.dart';
import '../empresa.dart';
import '../local.dart';
import '../dispositivo.dart';
import '../sensor.dart';
import '../tanque.dart';
import '../usuario.dart';
import '../leitura.dart';
import '../producao.dart';

class _BaseService<T extends EntidadeBase> {
  final DatabaseConnection db;
  final List<T> localList;
  final T Function(Map<String, dynamic>) mapper;
  int _nextId = 1;

  _BaseService(this.db, this.localList, this.mapper);

  Future<void> cadastrar(T entidade, String sql) async {
    localList.add(entidade);
    // Simula a escrita no banco
    await db.execute(sql, [/* params de entidade */]);
  }

  Future<List<T>> listar() async {
    // Simula a leitura do banco
    final results = await db.query('SELECT * FROM alguma_tabela');
    // Mapeamento real: converte os resultados do banco para objetos T
    return results.map((row) => mapper(row)).toList();
  }

  int getNextId() {
    if (localList.isNotEmpty) {
      _nextId = localList.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
    }
    return _nextId++;
  }
}

class EmpresaService extends _BaseService<Empresa> {
  EmpresaService(DatabaseConnection db, List<Empresa> list)
      : super(db, list, Empresa.fromMap);
  Future<void> cadastrarEmpresa(Empresa empresa) async =>
      super.cadastrar(empresa, 'INSERT INTO empresa (...) VALUES (...)');
}

class LocalService extends _BaseService<Local> {
  LocalService(DatabaseConnection db, List<Local> list)
      : super(db, list, Local.fromMap);
  Future<void> cadastrarLocal(Local local, int empresaId) async => super
      .cadastrar(local, 'INSERT INTO local (...) VALUES (..., $empresaId)');
}

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

class LeituraService {
  final DatabaseConnection db;
  final List<Leitura> leiturasLocais;

  LeituraService(this.db, this.leiturasLocais);

  // Simula a leitura do Firebase
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

  Future<List<Leitura>> listarBanco() async {
    // Simula buscar leituras já salvas no MySQL
    return []; // Retorna lista vazia para simular que não há nenhuma
  }

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

class ProducaoService {
  final DatabaseConnection db;
  final List<Producao> producoesLocais;
  int _nextId = 1;

  ProducaoService(this.db, this.producoesLocais);

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

  Future<void> enviarParaBanco(List<Producao> producoes, int sensorId) async {
    for (var producao in producoes) {
      await db.execute(
          'INSERT INTO producao (quantidade, data, sensor_id) VALUES (?, ?, ?)',
          [producao.quantidade, producao.dataHora.toIso8601String(), sensorId]);
    }
    print('✅ ${producoes.length} produções salvas no MySQL.');
  }
}
