// lib/dao/usuario_dao.dart
// Classe responsável pelas operações de acesso a dados (DAO) relacionadas à entidade Usuario.
// Contém métodos para leitura e inserção de registros na tabela 'usuario' do banco de dados.

import 'database/database_connection.dart';
import '../models/usuario.dart';

class UsuarioDao {
  // Instância da conexão ativa com o banco de dados
  final DatabaseConnection db;

  // Construtor que recebe a instância de conexão e associa à DAO
  UsuarioDao(this.db);

  // Método responsável por buscar todos os usuários cadastrados na tabela 'usuario'
  Future<List<Usuario>> fetchAll() async {
    // Lista que armazenará os objetos Usuario retornados do banco
    final usuarios = <Usuario>[];

    try {
      // Executa a consulta SQL para selecionar todos os usuários
      var resultados = await db.connection!.query('SELECT * FROM usuario');

      // Percorre o conjunto de resultados retornado pela consulta
      for (var row in resultados) {
        // Converte a linha em uma lista genérica para facilitar o acesso aos índices
        var dados = row.toList();

        // Verifica se há pelo menos 3 colunas válidas (id, nome, email)
        if (dados.length >= 3) {
          // Cria um novo objeto Usuario com base nos dados obtidos
          usuarios.add(Usuario(
            (dados[0] as num).toInt(),                     // ID do usuário
            dados[1].toString(),                           // Nome
            dados.length > 2 ? dados[2].toString() : 'email@exemplo.com', // E-mail (valor padrão se não houver)
            dados.length > 3 ? dados[3].toString() : 'senha',              // Senha (valor padrão)
            dados.length > 4 ? dados[4].toString() : 'Usuario',            // Perfil (valor padrão)
            DateTime.now(), // ⚠️ Substituto temporário — idealmente deveria vir do banco (dataCriacao)
            DateTime.now(), // ⚠️ Substituto temporário — idealmente deveria vir do banco (ultimoLogin)
            dados.length > 7 ? (dados[7] as num).toInt() : 1, // ID da empresa associada
          ));
        }
      }
    } catch (e) {
      // Captura e exibe erros de execução da consulta (ex: falha de conexão)
      print('❌ Erro ao carregar usuários: $e');
    }

    // Retorna a lista de usuários carregados do banco
    return usuarios;
  }

  // Método responsável por inserir um novo usuário na tabela 'usuario'
  Future<Usuario?> insert(Usuario usuario) async {
    try {
      // Executa a query de inserção, passando os valores dos campos do objeto Usuario
      var resultado = await db.connection!.query(
        'INSERT INTO usuario (nome, email, senhaLogin, perfil, dataCriacao, ultimoLogin, empresa_idEmpresa) VALUES (?, ?, ?, ?, ?, ?, ?)',
        [
          usuario.nome,                           // Nome completo do usuário
          usuario.email,                          // E-mail cadastrado
          usuario.senhaLogin,                     // Senha de login
          usuario.perfil,                         // Tipo de perfil (ex: Admin, Usuário)
          usuario.dataCriacao.toIso8601String(),  // Data de criação (convertida para formato ISO)
          usuario.ultimoLogin.toIso8601String(),  // Último login (convertido para formato ISO)
          usuario.empresaId,                      // ID da empresa à qual o usuário pertence
        ],
      );

      // Obtém o ID gerado automaticamente após a inserção
      final int? newId = resultado.insertId;

      // Caso o ID seja válido, retorna um novo objeto Usuario com o ID atualizado
      if (newId != null && newId > 0) {
        return Usuario(
          newId,
          usuario.nome,
          usuario.email,
          usuario.senhaLogin,
          usuario.perfil,
          usuario.dataCriacao,
          usuario.ultimoLogin,
          usuario.empresaId,
        );
      }

      // Caso a inserção falhe, retorna null
      return null;
    } catch (e) {
      // Captura e exibe possíveis erros durante o processo de inserção
      print('❌ Erro ao salvar usuário: $e');
      rethrow; // Relança o erro para ser tratado em outro ponto da aplicação
    }
  }
}
