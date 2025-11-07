// lib/controllers/consulta_controller.dart

import '../services/empresa_service.dart';
import '../services/local_service.dart';
import '../services/tanque_service.dart';
import '../services/dispositivo_service.dart';
import '../services/sensor_service.dart';
import '../services/usuario_service.dart';
import '../services/leitura_service.dart';

class ConsultaController {
  final EmpresaService _empresaService;
  final LocalService _localService;
  final TanqueService _tanqueService;
  final DispositivoService _dispositivoService;
  final SensorService _sensorService;
  final UsuarioService _usuarioService;
  final LeituraService _leituraService;

  ConsultaController(
    this._empresaService,
    this._localService,
    this._tanqueService,
    this._dispositivoService,
    this._sensorService,
    this._usuarioService,
    this._leituraService,
  );

  // -------------------------------------------------------------------
  // MÉTODOS DE LISTAGEM
  // -------------------------------------------------------------------

  /// Lista todas as empresas cadastradas.
  Future<void> listarEmpresas() async {
    print('\n🏢 LISTA DE EMPRESAS');
    print('═' * 50);

    try {
      final empresas = await _empresaService.listarTodos();

      if (empresas.isEmpty) {
        print('📭 Nenhuma empresa cadastrada.');
        return;
      }

      for (final empresa in empresas) {
        empresa.exibirDados();
        print('─' * 30);
      }

      print('📊 Total de empresas: ${empresas.length}');
    } catch (e) {
      print('❌ Erro ao listar empresas: $e');
    }
  }

  /// Lista todos os locais cadastrados.
  Future<void> listarLocais() async {
    print('\n📍 LISTA DE LOCAIS');
    print('═' * 50);

    try {
      final locais = await _localService.listarTodos();

      if (locais.isEmpty) {
        print('📭 Nenhum local cadastrado.');
        return;
      }

      for (final local in locais) {
        local.exibirDados();
        print('─' * 30);
      }

      print('📊 Total de locais: ${locais.length}');
    } catch (e) {
      print('❌ Erro ao listar locais: $e');
    }
  }

  /// Lista todos os tanques cadastrados.
  Future<void> listarTanques() async {
    print('\n🛢️ LISTA DE TANQUES');
    print('═' * 50);

    try {
      final tanques = await _tanqueService.listar();

      if (tanques.isEmpty) {
        print('📭 Nenhum tanque cadastrado.');
        return;
      }

      for (final tanque in tanques) {
        tanque.exibirDados();
        print('─' * 30);
      }

      print('📊 Total de tanques: ${tanques.length}');
    } catch (e) {
      print('❌ Erro ao listar tanques: $e');
    }
  }

  /// Lista todos os dispositivos cadastrados.
  Future<void> listarDispositivos() async {
    print('\n⚙️ LISTA DE DISPOSITIVOS');
    print('═' * 50);

    try {
      final dispositivos = await _dispositivoService.listar();

      if (dispositivos.isEmpty) {
        print('📭 Nenhum dispositivo cadastrado.');
        return;
      }

      for (final dispositivo in dispositivos) {
        dispositivo.exibirDados();
        print('─' * 30);
      }

      print('📊 Total de dispositivos: ${dispositivos.length}');
    } catch (e) {
      print('❌ Erro ao listar dispositivos: $e');
    }
  }

  /// Lista todos os sensores cadastrados.
  Future<void> listarSensores() async {
    print('\n📡 LISTA DE SENSORES');
    print('═' * 50);

    try {
      final sensores = await _sensorService.listar();

      if (sensores.isEmpty) {
        print('📭 Nenhum sensor cadastrado.');
        return;
      }

      for (final sensor in sensores) {
        sensor.exibirDados();
        print('─' * 30);
      }

      print('📊 Total de sensores: ${sensores.length}');
    } catch (e) {
      print('❌ Erro ao listar sensores: $e');
    }
  }

  /// Lista todos os usuários cadastrados.
  Future<void> listarUsuarios() async {
    print('\n👤 LISTA DE USUÁRIOS');
    print('═' * 50);

    try {
      final usuarios = await _usuarioService.listar();

      if (usuarios.isEmpty) {
        print('📭 Nenhum usuário cadastrado.');
        return;
      }

      for (final usuario in usuarios) {
        usuario.exibirDados();
        print('─' * 30);
      }

      print('📊 Total de usuários: ${usuarios.length}');
    } catch (e) {
      print('❌ Erro ao listar usuários: $e');
    }
  }

  /// Lista todas as leituras cadastradas.
  Future<void> listarLeituras() async {
    print('\n📊 LISTA DE LEITURAS');
    print('═' * 50);

    try {
      final leituras = await _leituraService.listarBanco();

      if (leituras.isEmpty) {
        print('📭 Nenhuma leitura cadastrada.');
        return;
      }

      for (final leitura in leituras) {
        leitura.exibirDados();
        print('─' * 30);
      }

      print('📊 Total de leituras: ${leituras.length}');
    } catch (e) {
      print('❌ Erro ao listar leituras: $e');
    }
  }
}
