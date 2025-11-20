// lib/models/service_locator.dart

import '../../dao/database/database_connection.dart';

// DAOs
import '../../dao/empresa_dao.dart';
import '../../dao/local_dao.dart';
import '../../dao/dispositivo_dao.dart';
import '../../dao/sensor_dao.dart';
import '../../dao/tanque_dao.dart';
import '../../dao/usuario_dao.dart';
import '../../dao/leitura_dao.dart';
import '../../dao/producao_dao.dart';

// Services
import '../../services/empresa_service.dart';
import '../../services/local_service.dart';
import '../../services/dispositivo_service.dart';
import '../../services/sensor_service.dart';
import '../../services/tanque_service.dart';
import '../../services/usuario_service.dart';
import '../../services/leitura_service.dart';
import '../../services/producao_service.dart';


// Responsável por centralizar todas as instâncias de DAO e Service.
// Deve ser inicializado **antes de abrir o Menu**.
// POO: Padrão Singleton - garante uma única instância global
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;

  // POO: Construtor privado para impedir instanciação externa
  ServiceLocator._internal();

  // Conexão com o banco
  late DatabaseConnection _db;

  // DAOs
  late EmpresaDao empresaDao;
  late LocalDao localDao;
  late DispositivoDao dispositivoDao;
  late SensorDao sensorDao;
  late TanqueDao tanqueDao;
  late UsuarioDao usuarioDao;
  late LeituraDao leituraDao;
  late ProducaoDao producaoDao;

  // Services
  late EmpresaService empresaService;
  late LocalService localService;
  late DispositivoService dispositivoService;
  late SensorService sensorService;
  late TanqueService tanqueService;
  late UsuarioService usuarioService;
  late LeituraService leituraService;
  late ProducaoService producaoService;

  // LÓGICA: Método de inicialização que configura toda a hierarquia de dependências
  Future<void> init(DatabaseConnection db) async {
    _db = db;

    // POO: Instanciação dos DAOs - camada de acesso a dados
    // Cada DAO recebe a conexão com o banco para executar operações
    empresaDao = EmpresaDao(_db);
    localDao = LocalDao(_db);
    dispositivoDao = DispositivoDao(_db);
    sensorDao = SensorDao(_db);
    tanqueDao = TanqueDao(_db);
    usuarioDao = UsuarioDao(_db);
    leituraDao = LeituraDao(_db);
    producaoDao = ProducaoDao(_db);

    // POO: Instanciação dos Services - camada de lógica de negócio
    // Cada Service recebe seu respectivo DAO para operações de persistência
    empresaService = EmpresaService.fromDao(empresaDao);
    localService = LocalService.fromDao(localDao);
    dispositivoService = DispositivoService.fromDao(dispositivoDao);
    sensorService = SensorService.fromDao(sensorDao);
    tanqueService = TanqueService.fromDao(tanqueDao);
    usuarioService = UsuarioService.fromDao(usuarioDao);
    leituraService = LeituraService.fromDao(leituraDao);
    producaoService = ProducaoService.fromDao(producaoDao);
  }
}