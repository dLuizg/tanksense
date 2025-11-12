// lib/models/usuario.dart
import 'entidade_base.dart';

// POO: Classe Usuario que herda de EntidadeBase
// Representa um usuário do sistema com dados de autenticação e permissões
class Usuario extends EntidadeBase {
  final String _nome;
  final String _email;
  final String _senhaLogin;
  final String _perfil;
  final DateTime _dataCriacao;
  DateTime _ultimoLogin;
  final int _empresaId;
  final List<String> _permissoes = [];

  // CORREÇÃO: Construtor posicional para compatibilidade com a classe base
  // POO: Construtor principal que inicializa todos os atributos e define permissões
  Usuario(
    super.id,
    this._nome,
    this._email,
    this._senhaLogin,
    this._perfil,
    this._dataCriacao,
    this._ultimoLogin,
    this._empresaId,
  ) {
    _definirPermissoes(); // Define as permissões automaticamente na criação
  }

  // POO: Factory method para criação com parâmetros nomeados (mais legível)
  // LÓGICA: Oferece alternativa mais clara para instanciação do objeto
  factory Usuario.criar({
    required int id,
    required String nome,
    required String email,
    required String senhaLogin,
    required String perfil,
    required DateTime dataCriacao,
    required DateTime ultimoLogin,
    required int empresaId,
  }) {
    return Usuario(
      id,
      nome,
      email,
      senhaLogin,
      perfil,
      dataCriacao,
      ultimoLogin,
      empresaId,
    );
  }

  // POO: Getters para acesso controlado aos atributos privados
  String get nome => _nome;
  String get email => _email;
  String get senhaLogin => _senhaLogin;
  String get perfil => _perfil;
  DateTime get dataCriacao => _dataCriacao;
  DateTime get ultimoLogin => _ultimoLogin;
  int get empresaId => _empresaId;
  List<String> get permissoes => List.unmodifiable(_permissoes);

  // POO: Implementação do método abstrato para exibição dos dados do usuário
  @override
  void exibirDados() {
    print('👤 DADOS DO USUÁRIO');
    print('─' * 30);
    print('ID: $id');
    print('Nome: $_nome');
    print('Email: $_email');
    print('Perfil: $_perfil');
    print('Data de Criação: ${_formatarData(_dataCriacao)}');
    print('Último Login: ${_formatarData(_ultimoLogin)}');
    print('Empresa ID: $_empresaId');
    print('Permissões: ${_permissoes.length}');
    print('Tipo: ${obterTipo()}');
    print('─' * 30);
  }

  // POO: Implementação do método abstrato para identificar o tipo de entidade
  @override
  String obterTipo() {
    return "Usuário do Sistema";
  }

  // LÓGICA: Define as permissões do usuário baseadas no perfil atribuído
  // Hierarquia de permissões: Visualizador < Operador < Administrador
  void _definirPermissoes() {
    List<String> permissoesBase = ['visualizar_dados'];

    if (isAdministrador()) {
      permissoesBase
          .addAll(['gerenciar_usuarios', 'configurar_sistema', 'acesso_total']);
    }

    if (isOperador() || isAdministrador()) {
      permissoesBase.addAll(['cadastrar_dados', 'editar_dados']);
    }

    _permissoes.addAll(permissoesBase);
  }

  // LÓGICA: Atualiza o timestamp do último login do usuário
  void atualizarUltimoLogin() {
    _ultimoLogin = DateTime.now();
    print('🕒 Último login atualizado para: ${_formatarData(_ultimoLogin)}');
  }

  // LÓGICA: Métodos para verificação do perfil do usuário
  bool isAdministrador() {
    if (_perfil.toLowerCase() == 'administrador') {
      return true;
    } else {
      return false;
    }
  }

  bool isOperador() {
    return _perfil.toLowerCase() == 'operador';
  }

  bool isVisualizador() {
    return _perfil.toLowerCase() == 'visualizador';
  }

  // LÓGICA: Valida o formato do email usando expressão regular
  bool emailValido() {
    bool validarEmail(String email) {
      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
      return emailRegex.hasMatch(email);
    }

    return validarEmail(_email);
  }

  // LÓGICA: Exibe todas as permissões atribuídas ao usuário
  void exibirPermissoes() {
    print('🔐 Permissões do Usuário:');
    for (String permissao in _permissoes) {
      print('  ✅ $permissao');
    }
  }

  // LÓGICA: Verifica se o usuário possui uma permissão específica
  bool temPermissao(String permissao) {
    return _permissoes.contains(permissao);
  }

  // LÓGICA: Simula a alteração de senha com validação de comprimento mínimo
  void alterarSenha(String novaSenha) {
    if (novaSenha.length >= 6) {
      print('🔒 Senha alterada com sucesso!');
    } else {
      print('❌ Senha deve ter pelo menos 6 caracteres!');
    }
  }

  // LÓGICA: Formata data para exibição no padrão brasileiro
  String _formatarData(DateTime data) {
    return '${data.day}/${data.month}/${data.year} ${data.hour}:${data.minute.toString().padLeft(2, '0')}';
  }

  // POO: Implementação do método para serialização em mapa
  @override
  Map<String, dynamic> toMap() {
    return {
      'idUsuario': id,
      'nome': _nome,
      'email': _email,
      'senhaLogin': _senhaLogin,
      'perfil': _perfil,
      'dataCriacao': _dataCriacao.toIso8601String(),
      'ultimoLogin': _ultimoLogin.toIso8601String(),
      'empresa_idEmpresa': _empresaId,
      'permissoes': _permissoes,
    };
  }

  // POO: Sobrescrita do método toString para representação textual
  @override
  String toString() {
    return 'Usuario{id: $id, nome: $_nome, email: $_email, perfil: $_perfil}';
  }
}