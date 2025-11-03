// lib/controllers/gestao_organizacional_controller.dart
import '../empresa.dart';
import '../local.dart';
import '../usuario.dart';
import '../services/empresa_service.dart';
import '../services/local_service.dart';
import '../services/usuario_service.dart';
import 'dart:async'; // Para DateTime

class GestaoOrganizacionalController {
  final EmpresaService _empresaService;
  final LocalService _localService;
  final UsuarioService _usuarioService;

  GestaoOrganizacionalController(
    this._empresaService,
    this._localService,
    this._usuarioService,
  );

  Future<Empresa?> cadastrarEmpresa(String nome, String cnpj) async {
    print('Controller: Cadastrando empresa...');
    try {
      final novaEmpresa = Empresa(0, nome, cnpj);

      // CORREÇÃO: Chamamos o service (que retorna void/int)
      await _empresaService.cadastrar(novaEmpresa);

      // Retornamos o objeto local (com ID 0)
      return novaEmpresa;
    } catch (e) {
      print('❌ Erro no cadastro da empresa: $e');
      return null;
    }
  }

  Future<Local?> cadastrarLocal(
      String nome, String referencia, int empresaId) async {
    print('Controller: Cadastrando local...');
    try {
      final novoLocal = Local(0, nome, referencia, empresaId);

      // CORREÇÃO: Chamamos o service (que retorna void/int)
      await _localService.cadastrar(novoLocal);

      // Retornamos o objeto local (com ID 0)
      return novoLocal;
    } catch (e) {
      print('❌ Erro no cadastro do local: $e');
      return null;
    }
  }

  Future<Usuario?> cadastrarUsuario(String nome, String email, String senha,
      String perfil, int empresaId) async {
    print('Controller: Cadastrando usuário...');
    try {
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

      // CORREÇÃO: Chamamos o service (que retorna void/int)
      await _usuarioService.cadastrar(novoUsuario);

      // Retornamos o objeto local (com ID 0)
      return novoUsuario;
    } catch (e) {
      print('❌ Erro no cadastro do usuário: $e');
      return null;
    }
  }
}
