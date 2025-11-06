// lib/menu.dart
import 'dart:io';
import 'service_locator.dart';
import 'empresa.dart';
import 'local.dart';
import 'dispositivo.dart';
import 'sensor.dart';
import 'tanque.dart';
import 'usuario.dart';
import 'producao.dart';
import '../controllers/data_controller.dart'; // <-- 1. IMPORTAR O CONTROLLER

class Menu {
  // --- MODIFICAÇÃO (POO) ---
  // A View (Menu) deve depender de Controllers (orquestradores)
  // e não diretamente de Services (regras de negócio).
  // Estamos mantendo os services por enquanto, mas adicionando o DataController
  // que é necessário para as funções de Leitura/Produção.

  final _empresaService = ServiceLocator().empresaService;
  final _localService = ServiceLocator().localService;
  final _dispositivoService = ServiceLocator().dispositivoService;
  final _sensorService = ServiceLocator().sensorService;
  final _tanqueService = ServiceLocator().tanqueService;
  final _usuarioService = ServiceLocator().usuarioService;
  final _leituraService = ServiceLocator().leituraService;
  final _producaoService = ServiceLocator().producaoService;

  // O DataController orquestra operações complexas (como carregar e processar)
  final _dataController = DataController(); // <-- 2. INSTANCIAR O CONTROLLER

  Future<void> iniciar() async {
    while (true) {
      _limparTela();

      print("""
==================== MENU PRINCIPAL ====================

1 - 🏭 Empresas
2 - 🏠 Locais
3 - ⚙️ Dispositivos
4 - 📡 Sensores
5 - 🛢️ Tanques
6 - 👤 Usuários
7 - 📜 Leituras (Sincronização e Listagem)
8 - ✏️ Produção (Processamento e Listagem)

0 - ✖️ Sair
""");

      stdout.write("Escolha uma opção: ");
      final opcao = stdin.readLineSync();

      switch (opcao) {
        case '1':
          await _menuEmpresas();
          break;
        case '2':
          await _menuLocais();
          break;
        case '3':
          await _menuDispositivos();
          break;
        case '4':
          await _menuSensores();
          break;
        case '5':
          await _menuTanques();
          break;
        case '6':
          await _menuUsuarios();
          break;
        case '7':
          await _menuLeituras();
          break;
        case '8':
          await _menuProducao();
          break;
        case '0':
          print("Saindo...");
          exit(0);
        default:
          print("Opção inválida!");
          await _pausar();
      }
    }
  }

  // ------------------ SUB MENUS ------------------

  Future<void> _menuEmpresas() async {
    // ... (sem mudanças)
    _limparTela();
    print("""
-------- EMPRESAS --------
1 - 📝 Cadastrar Empresa
2 - 📋 Listar Empresas
0 - 🔙 Voltar
""");
    stdout.write("Opção: ");
    switch (stdin.readLineSync()) {
      case '1':
        await _cadastrarEmpresa();
        break;
      case '2':
        await _listarEmpresas();
        break;
    }
  }

  Future<void> _menuLocais() async {
    // ... (sem mudanças)
    _limparTela();
    print("""
-------- LOCAIS --------
1 - 📝 Cadastrar Local
2 - 📋 Listar Locais
0 - 🔙 Voltar
""");
    stdout.write("Opção: ");
    switch (stdin.readLineSync()) {
      case '1':
        await _cadastrarLocal();
        break;
      case '2':
        await _listarLocais();
        break;
    }
  }

  Future<void> _menuDispositivos() async {
    // ... (sem mudanças)
    _limparTela();
    print("""
-------- DISPOSITIVOS --------
1 - 📝 Cadastrar Dispositivo
2 - 📋 Listar Dispositivos
0 - 🔙 Voltar
""");
    stdout.write("Opção: ");
    switch (stdin.readLineSync()) {
      case '1':
        await _cadastrarDispositivo();
        break;
      case '2':
        await _listarDispositivos();
        break;
    }
  }

  Future<void> _menuSensores() async {
    // ... (sem mudanças)
    _limparTela();
    print("""
-------- SENSORES --------
1 - 📝 Cadastrar Sensor
2 - 📋 Listar Sensores
0 - 🔙 Voltar
""");
    stdout.write("Opção: ");
    switch (stdin.readLineSync()) {
      case '1':
        await _cadastrarSensor();
        break;
      case '2':
        await _listarSensores();
        break;
    }
  }

  Future<void> _menuTanques() async {
    // ... (sem mudanças)
    _limparTela();
    print("""
-------- TANQUES --------
1 - 📝 Cadastrar Tanque
2 - 📋 Listar Tanques
0 - 🔙 Voltar
""");
    stdout.write("Opção: ");
    switch (stdin.readLineSync()) {
      case '1':
        await _cadastrarTanque();
        break;
      case '2':
        await _listarTanques();
        break;
    }
  }

  Future<void> _menuUsuarios() async {
    // ... (sem mudanças)
    _limparTela();
    print("""
-------- USUÁRIOS --------
1 - 📝 Cadastrar Usuário
2 - 📋 Listar Usuários
0 - 🔙 Voltar
""");
    stdout.write("Opção: ");
    switch (stdin.readLineSync()) {
      case '1':
        await _cadastrarUsuario();
        break;
      case '2':
        await _listarUsuarios();
        break;
    }
  }

  // --- CORREÇÃO (undefined_method) ---
  // Os métodos 'atualizarLeituras' e 'listarLeituras' foram
  // removidos do Service (Violação do SRP).
  // A View (Menu) agora chama a lógica correta.
  Future<void> _menuLeituras() async {
    _limparTela();
    print("""
-------- LEITURAS --------
1 - Sincronizar Leituras (Firebase/IA)
2 - Processar Produção Diária (Baseado nas leituras)
3 - Listar Últimas Leituras (Do banco local)
0 - Voltar
""");
    stdout.write("Opção: ");
    switch (stdin.readLineSync()) {
      case '1':
        // 1. A View chama o Controller
        print("Qual o ID do Sensor para sincronizar?");
        final sensorId = int.tryParse(stdin.readLineSync() ?? '0') ?? 0;
        if (sensorId <= 0) {
          print("ID de sensor inválido.");
          break;
        }
        // Usamos o DataController (que tem a lógica de orquestração)
        await _dataController.carregarESincronizarLeituras(
            'tanksense---v2-default-rtdb.firebaseio.com', sensorId);
        break;
      case '2':
        // 2. A View chama o Controller
        print("Qual o ID do Tanque para processar a produção?");
        final tanqueId = int.tryParse(stdin.readLineSync() ?? '0') ?? 0;
        // O Controller retorna os dados, a View exibe
        final producao =
            await _dataController.processarProducaoDiaria(tanqueId);
        if (producao == null) {
          print("Nenhuma produção registrada.");
        }
        break;
      case '3':
        // 3. A View chama o novo método de listagem
        await _listarLeituras();
        break;
    }
    await _pausar();
  }

  // --- CORREÇÃO (undefined_method) ---
  // Os métodos 'registrarProducao' e 'listarProducao' foram
  // removidos do Service (Violação do SRP).
  Future<void> _menuProducao() async {
    _limparTela();
    print("""
-------- PRODUÇÃO --------
1 - Registrar Produção Manual
2 - Listar Registros de Produção
0 - Voltar
""");
    stdout.write("Opção: ");
    switch (stdin.readLineSync()) {
      case '1':
        // 1. A View chama o novo método de cadastro
        await _cadastrarProducaoManual();
        break;
      case '2':
        // 2. A View chama o novo método de listagem
        await _listarProducao();
        break;
    }
    await _pausar();
  }

  // ------------------ AÇÕES CRUD (COM CORREÇÕES) ------------------

  Future<void> _cadastrarEmpresa() async {
    // (Este método já estava correto e serviu de modelo)
    try {
      stdout.write("Nome da Empresa: ");
      final nome = stdin.readLineSync()!;
      stdout.write("CNPJ da Empresa: ");
      final cnpj = stdin.readLineSync()!;
      await _empresaService.cadastrar(Empresa(0, nome, cnpj));
      print("Empresa cadastrada com sucesso!");
    } catch (e) {
      print("❌ Erro ao cadastrar empresa: $e");
    }
    await _pausar();
  }

  Future<void> _listarEmpresas() async {
    // ✅ CORREÇÃO
    final lista = await _empresaService.listar(); // <-- Esta linha está CORRETA
    print("\n--- Empresas ---");
    for (var e in lista) {
      print("${e.id} - ${e.nome}");
    }
    await _pausar();
  }

  // --- CORREÇÃO (Causa do RangeError) ---
  // O menu (View) é responsável por coletar TODOS os dados necessários.
  Future<void> _cadastrarLocal() async {
    try {
      stdout.write("Nome do Local(Sem acentos): ");
      final nome = stdin.readLineSync()!;
      stdout.write("Referência (Ex: Bloco A, Setor 2): ");
      final referencia = stdin.readLineSync()!;
      stdout.write("ID da Empresa (a qual este local pertence): ");
      final empresaId = int.tryParse(stdin.readLineSync() ?? '0') ?? 0;

      // Não usamos mais o .criar(nome), que tinha placeholders.
      // Nós criamos o objeto completo aqui na View.
      final novoLocal = Local(0, nome, referencia, empresaId);

      // E chamamos o .cadastrar(objeto)
      await _localService.cadastrar(novoLocal);
      print("Local cadastrado!");
    } catch (e) {
      // Se o 'empresaId' não existir, o Service agora lança um ArgumentError
      // (que é melhor que o RangeError).
      print("❌ Erro ao salvar local: $e");
    }
    await _pausar();
  }

  Future<void> _listarLocais() async {
    final lista = await _localService.listar();
    print("\n--- Locais ---");
    // --- CORREÇÃO (Linter) ---
    for (var l in lista) {
      print("${l.id} - ${l.nome}");
    }
    await _pausar();
  }

  // --- CORREÇÃO (Causa do RangeError) ---
  Future<void> _cadastrarDispositivo() async {
    try {
      stdout.write("Modelo do Dispositivo (Ex: ESP32, Tank-001): ");
      final modelo = stdin.readLineSync()!;
      stdout.write("Status Inicial (Ex: Ativo, Inativo, Manutenção): ");
      final status = stdin.readLineSync()!;

      final novoDispositivo = Dispositivo(0, modelo, status);
      await _dispositivoService.cadastrar(novoDispositivo);
      print("Dispositivo cadastrado!");
    } catch (e) {
      print("❌ Erro ao salvar dispositivo: $e");
    }
    await _pausar();
  }

  Future<void> _listarDispositivos() async {
    final lista = await _dispositivoService.listar();
    print("\n--- Dispositivos ---");
    // --- CORREÇÃO (Linter) ---
    for (var d in lista) {
      // (Assumindo que Dispositivo tem 'modelo' e não 'nome')
      print("${d.id} - ${d.modelo} (${d.status})");
    }
    await _pausar();
  }

  // --- CORREÇÃO (Causa do RangeError) ---
  Future<void> _cadastrarSensor() async {
    try {
      stdout.write("Tipo do Sensor (Ex: Ultrassônico, Nível): ");
      final tipo = stdin.readLineSync()!;
      stdout.write("Unidade de Medida (Ex: cm, %): ");
      final unidade = stdin.readLineSync()!;
      stdout.write("ID do Dispositivo (ao qual este sensor pertence): ");
      final dispositivoId = int.tryParse(stdin.readLineSync() ?? '0') ?? 0;

      final novoSensor = Sensor(0, tipo, unidade, dispositivoId);
      await _sensorService.cadastrar(novoSensor);
      print("Sensor cadastrado!");
    } catch (e) {
      print("❌ Erro ao salvar sensor: $e");
    }
    await _pausar();
  }

  Future<void> _listarSensores() async {
    final lista = await _sensorService.listar();
    print("\n--- Sensores ---");
    // --- CORREÇÃO (Linter) ---
    for (var s in lista) {
      // (Assumindo que Sensor tem 'tipo' e não 'nome')
      print("${s.id} - ${s.tipo} (${s.unidadeMedida})");
    }
    await _pausar();
  }

  // --- CORREÇÃO (Causa do RangeError) ---
  Future<void> _cadastrarTanque() async {
    try {
      stdout.write("Altura do Tanque (em cm): ");
      final altura = double.tryParse(stdin.readLineSync() ?? '0.0') ?? 0.0;
      stdout.write("Volume Máximo (em litros): ");
      final volMax = double.tryParse(stdin.readLineSync() ?? '0.0') ?? 0.0;
      stdout.write("ID do Local (onde o tanque está): ");
      final localId = int.tryParse(stdin.readLineSync() ?? '0') ?? 0;
      stdout.write("ID do Dispositivo (que monitora o tanque): ");
      final dispositivoId = int.tryParse(stdin.readLineSync() ?? '0') ?? 0;

      // O volume atual é 0.0 no cadastro
      final novoTanque = Tanque(0, altura, volMax, 0.0);
      await _tanqueService.cadastrar(novoTanque, localId, dispositivoId);
      print("Tanque cadastrado!");
    } catch (e) {
      print("❌ Erro ao salvar tanque: $e");
    }
    await _pausar();
  }

  Future<void> _listarTanques() async {
    final lista = await _tanqueService.listar();
    print("\n--- Tanques ---");
    // --- CORREÇÃO (Linter) ---
    for (var t in lista) {
      // (Assumindo que Tanque não tem 'nome', mas tem 'id' e 'altura')
      print(
          "${t.id} - Altura: ${t.altura}cm, Vol: ${t.volumeAtual}L / ${t.volumeMax}L");
    }
    await _pausar();
  }

  // --- CORREÇÃO (Causa do RangeError) ---
  Future<void> _cadastrarUsuario() async {
    try {
      stdout.write("Nome do Usuário: ");
      final nome = stdin.readLineSync()!;
      stdout.write("Email: ");
      final email = stdin.readLineSync()!;
      stdout.write("Senha: ");
      final senha = stdin.readLineSync()!;
      stdout.write("Perfil (Ex: Admin, Operador): ");
      final perfil = stdin.readLineSync()!;
      stdout.write("ID da Empresa (à qual o usuário pertence): ");
      final empresaId = int.tryParse(stdin.readLineSync() ?? '0') ?? 0;

      // Usamos o Factory 'criar' do Usuario (que é uma boa prática de POO)
      final novoUsuario = Usuario.criar(
        id: 0,
        nome: nome,
        email: email,
        senhaLogin: senha,
        perfil: perfil,
        dataCriacao: DateTime.now(),
        ultimoLogin: DateTime.now(),
        empresaId: empresaId,
      );
      await _usuarioService.cadastrar(novoUsuario);
      print("Usuário cadastrado!");
    } catch (e) {
      print("❌ Erro ao salvar usuário: $e");
    }
    await _pausar();
  }

  Future<void> _listarUsuarios() async {
    final lista = await _usuarioService.listar();
    print("\n--- Usuários ---");
    // --- CORREÇÃO (Linter) ---
    for (var u in lista) {
      print("${u.id} - ${u.nome} (${u.email})");
    }
    await _pausar();
  }

  // --- NOVOS MÉTODOS (POO) ---
  // Esta é a lógica de View (print) que foi removida dos Services

  Future<void> _listarLeituras() async {
    print('\n📊 LISTA DE LEITURAS (do Banco Local)');
    print('═' * 50);
    try {
      // 1. A View chama o Service para PEGAR os dados
      final leituras = await _leituraService.listarBanco();
      if (leituras.isEmpty) {
        print('📭 Nenhuma leitura encontrada.');
        return;
      }
      // 2. A View é responsável por EXIBIR os dados
      for (final leitura in leituras) {
        leitura.exibirDados(); // O Modelo sabe se exibir
        print('─' * 30);
      }
      print('📊 Total de leituras: ${leituras.length}');
    } catch (e) {
      print('❌ Erro ao listar leituras: $e');
    }
  }

  Future<void> _cadastrarProducaoManual() async {
    print('\n🏭 REGISTRAR PRODUÇÃO MANUAL');
    try {
      stdout.write("Quantidade produzida (em metros): ");
      final quantidade = double.tryParse(stdin.readLineSync() ?? '0.0') ?? 0.0;
      stdout.write("Detalhes/Observação: ");
      final detalhes = stdin.readLineSync()!;
      stdout.write("ID do Sensor (que mediu a produção): ");
      final sensorId = int.tryParse(stdin.readLineSync() ?? '0') ?? 0;

      final producao = Producao(
        0, // ID 0 (temporário)
        sensorId,
        DateTime.now(),
        quantidade,
        'Manual',
        detalhes,
      );

      // A View chama o Service de negócio
      await _producaoService.cadastrarProducaoManual(producao);
      print('✅ Produção registrada com sucesso.');
    } catch (e) {
      print('❌ Erro ao registrar produção: $e');
    }
  }

  Future<void> _listarProducao() async {
    print('\n🏭 LISTA DE PRODUÇÃO');
    print('═' * 50);
    try {
      // 1. A View chama o Service para PEGAR os dados
      final producoes = await _producaoService.listarTodos();
      if (producoes.isEmpty) {
        print('📭 Nenhuma produção encontrada.');
        return;
      }
      // 2. A View é responsável por EXIBIR os dados
      for (final producao in producoes) {
        producao.exibirDados(); // O Modelo sabe se exibir
        print('─' * 30);
      }
      print('📊 Total de registros: ${producoes.length}');
    } catch (e) {
      print('❌ Erro ao listar produção: $e');
    }
  }

  // ------------------ FUNÇÕES AUXILIARES ------------------

  void _limparTela() => stdout.write("\x1B[2J\x1B[0;0H");
  Future<void> _pausar() async {
    stdout.write("\nPressione ENTER para continuar...");
    stdin.readLineSync();
  }
}
