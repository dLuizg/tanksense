// lib/controllers/consulta_controller.dart

// POO: Importando todas as classes de "Serviço".
// Cada serviço encapsula a lógica de negócio para uma entidade (ex: EmpresaService cuida de Empresas).
import '../services/empresa_service.dart';
import '../services/local_service.dart';
import '../services/tanque_service.dart';
import '../services/dispositivo_service.dart';
import '../services/sensor_service.dart';
import '../services/usuario_service.dart';
import '../services/leitura_service.dart';

// POO: Definição da classe 'ConsultaController'.
// Esta classe agrupa todos os métodos relacionados a "consultar" dados.
class ConsultaController {
  // POO: Declaração de atributos (campos) privados e finais.
  // Cada atributo armazena uma instância de um Serviço.
  // A classe 'ConsultaController' DEPENDE de todos esses serviços.
  final EmpresaService _empresaService;
  final LocalService _localService;
  final TanqueService _tanqueService;
  final DispositivoService _dispositivoService;
  final SensorService _sensorService;
  final UsuarioService _usuarioService;
  final LeituraService _leituraService;

  // POO: Construtor da classe.
  // Ele recebe instâncias de todos os serviços que precisa para funcionar.
  // Isso é um padrão muito bom chamado "Injeção de Dependência".
  ConsultaController(
    this._empresaService,
    this._localService,
    this._tanqueService,
    this._dispositivoService,
    this._sensorService,
    this._usuarioService,
    this._leituraService,
  );

  /// Lista todas as empresas cadastradas.
  // POO: Definição de um método público da classe.
  // LÓGICA: É um método assíncrono ('async') que não retorna valor ('void').
  // A única função dele é "fazer algo" (imprimir no console).
  Future<void> listarEmpresas() async {
    // LÓGICA: Imprime um cabeçalho formatado no console (feedback visual).
    print('\n🏢 LISTA DE EMPRESAS');
    print('═' * 50);

    // LÓGICA: Bloco 'try/catch' para tratamento de erros.
    try {
      // POO: Chama o método 'listarTodos' no objeto '_empresaService'.
      // LÓGICA: 'await' pausa a execução aqui até o serviço buscar os dados.
      final empresas = await _empresaService.listarTodos();

      // LÓGICA: Verificação condicional. Se a lista de empresas está vazia...
      if (empresas.isEmpty) {
        // LÓGICA: Imprime uma mensagem e...
        print('📭 Nenhuma empresa cadastrada.');
        // LÓGICA: ...sai do método imediatamente.
        return;
      }

      // LÓGICA: Se a lista não está vazia, inicia um loop 'for-each'.
      for (final empresa in empresas) {
        // POO: Chama o método 'exibirDados()' em cada objeto 'empresa'.
        // O próprio objeto 'empresa' sabe como se "imprimir" no console.
        empresa.exibirDados();
        // LÓGICA: Imprime um separador visual.
        print('─' * 30);
      }

      // LÓGICA: Imprime um rodapé com a contagem total de itens.
      print('📊 Total de empresas: ${empresas.length}');
    } catch (e) {
      // LÓGICA: Se qualquer coisa no 'try' falhar (ex: erro no banco),
      // o código pula para cá e imprime o erro.
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
