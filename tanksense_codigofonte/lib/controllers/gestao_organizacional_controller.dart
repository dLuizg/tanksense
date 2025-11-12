// lib/controllers/gestao_organizacional_controller.dart

// POO: Importando as classes (modelos) que definem a estrutura dos dados.
import '../models/empresa.dart';
import '../models/local.dart';
import '../models/usuario.dart';

// POO: Importando as classes de Serviço (que encapsulam as regras de negócio).
import '../services/empresa_service.dart';
import '../services/local_service.dart';
import '../services/usuario_service.dart';

// LÓGICA: Importando a biblioteca 'async' (necessária para DateTime e Future).
import 'dart:async'; // Para DateTime

// POO: Definição da classe 'GestaoOrganizacionalController'.
// Esta classe agrupa a lógica de *gerenciamento* (cadastro) de entidades
// organizacionais como empresas, locais e usuários.
class GestaoOrganizacionalController {
  // POO: Declaração de atributos (campos) privados e finais.
  // Cada atributo armazena uma instância de um Serviço.
  final EmpresaService _empresaService;
  final LocalService _localService;
  final UsuarioService _usuarioService;

  // POO: Construtor da classe.
  // Utiliza Injeção de Dependência para receber as instâncias dos serviços
  // que ele precisa para funcionar.
  GestaoOrganizacionalController(
    this._empresaService,
    this._localService,
    this._usuarioService,
  );

  // POO: Definição de um método da classe.
  // LÓGICA: Método assíncrono ('async') que pode retornar um objeto 'Empresa' ou 'null'.
  Future<Empresa?> cadastrarEmpresa(String nome, String cnpj) async {
    // LÓGICA: Imprime no console para fins de debug.
    print('Controller: Cadastrando empresa...');
    // LÓGICA: Inicia um bloco 'try/catch' para tratamento de erros.
    try {
      // POO: Cria uma nova instância (objeto) da classe 'Empresa'.
      // LÓGICA: O ID '0' é usado como um valor temporário (placeholder).
      final novaEmpresa = Empresa(0, nome, cnpj);

      // POO: Chama o método 'cadastrar' do objeto '_empresaService'.
      // LÓGICA: 'await' pausa a execução aqui até que o serviço termine.
      await _empresaService.cadastrar(novaEmpresa);

      // LÓGICA: Retorna o objeto 'novaEmpresa' criado localmente (com ID 0).
      return novaEmpresa;
    } catch (e) {
      // LÓGICA: Bloco 'catch' é executado se qualquer erro ocorrer no 'try'.
      print('❌ Erro no cadastro da empresa: $e');
      // LÓGICA: Retorna 'null' para sinalizar que o cadastro falhou.
      return null;
    }
  }

  // POO: Definição de um método da classe.
  // LÓGICA: Método assíncrono ('async') que pode retornar um 'Local' ou 'null'.
  Future<Local?> cadastrarLocal(
      String nome, String referencia, int empresaId) async {
    // LÓGICA: Imprime no console para fins de debug.
    print('Controller: Cadastrando local...');
    // LÓGICA: Inicia um bloco 'try/catch' para tratamento de erros.
    try {
      // POO: Cria uma nova instância (objeto) da classe 'Local'.
      final novoLocal = Local(0, nome, referencia, empresaId);

      // POO: Chama o método 'cadastrar' do objeto '_localService'.
      // LÓGICA: 'await' pausa a execução até o serviço terminar.
      await _localService.cadastrar(novoLocal);

      // LÓGICA: Retorna o objeto 'novoLocal' criado localmente (com ID 0).
      return novoLocal;
    } catch (e) {
      // LÓGICA: Bloco 'catch' para capturar falhas.
      print('❌ Erro no cadastro do local: $e');
      // LÓGICA: Retorna 'null' para sinalizar a falha.
      return null;
    }
  }

  // POO: Definição de um método da classe.
  // LÓGICA: Método assíncrono ('async') que pode retornar um 'Usuario' ou 'null'.
  Future<Usuario?> cadastrarUsuario(String nome, String email, String senha,
      String perfil, int empresaId) async {
    // LÓGICA: Imprime no console para fins de debug.
    print('Controller: Cadastrando usuário...');
    // LÓGICA: Inicia um bloco 'try/catch' para tratamento de erros.
    try {
      // POO: Cria uma nova instância de 'Usuario' usando um construtor nomeado ('.criar').
      // Isso é um padrão de fábrica (Factory Pattern) ou apenas um construtor
      // auxiliar para organizar melhor a criação do objeto.
      final novoUsuario = Usuario.criar(
        id: 0, // LÓGICA: ID '0' usado como placeholder.
        nome: nome,
        email: email,
        senhaLogin: senha,
        perfil: perfil,
        // LÓGICA: Pega a data e hora exatas do momento da criação.
        dataCriacao: DateTime.now(),
        ultimoLogin: DateTime.now(),
        empresaId: empresaId,
      );

      // POO: Chama o método 'cadastrar' do objeto '_usuarioService'.
      // LÓGICA: 'await' pausa a execução até o serviço terminar.
      await _usuarioService.cadastrar(novoUsuario);

      // LÓGICA: Retorna o objeto 'novoUsuario' criado localmente (com ID 0).
      return novoUsuario;
    } catch (e) {
      // LÓGICA: Bloco 'catch' para capturar falhas.
      print('❌ Erro no cadastro do usuário: $e');
      // LÓGICA: Retorna 'null' para sinalizar a falha.
      return null;
    }
  }
} // POO: Fim da definição da classe 'GestaoOrganizacionalController'.
