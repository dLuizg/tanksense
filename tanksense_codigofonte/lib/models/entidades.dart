// lib/models/entidades.dart

// POO: Definição da classe. Isto é um "molde" para criar objetos
// que simulam uma conexão com o banco de dados.
class DatabaseConnection {
  // POO: Definição de um método da classe.
  // LÓGICA: Método assíncrono ('async') que simula a abertura de conexão.
  // Retorna um 'Future<bool>' (um booleano no futuro) indicando sucesso.
  Future<bool> connect() async {
    // LÓGICA: 'await' pausa a execução aqui por 1 segundo, simulando
    // o tempo real que uma conexão de rede levaria.
    await Future.delayed(Duration(seconds: 1));
    // LÓGICA: Retorna 'true' para fingir que a conexão sempre dá certo.
    return true;
  }

  // POO: Outro método da classe.
  // LÓGICA: Método assíncrono que simula o fechamento da conexão.
  // 'void' significa que ele não retorna nenhum valor, apenas executa uma ação.
  Future<void> close() async {
    // LÓGICA: Ação de simulação, apenas imprime no console.
    print('Banco de dados fechado.');
  }

  // POO: Método para executar comandos que modificam o banco (INSERT, UPDATE, DELETE).
  // LÓGICA: Recebe dois parâmetros: a string 'sql' e uma lista opcional 'params'.
  // O '[]' em [List<dynamic>? params] torna o segundo parâmetro opcional.
  Future<int> execute(String sql, [List<dynamic>? params]) async {
    // LÓGICA: Linha comentada que seria usada para debug (ver o que está rodando).
    // print('Executando SQL: $sql com params: $params');

    // LÓGICA: Retorna '1' para simular que 1 linha do banco foi afetada.
    return 1;
  }

  // POO: Método para executar consultas que leem dados (SELECT).
  // LÓGICA: Retorna um 'Future' que conterá uma Lista de Mapas.
  // 'List<Map<String, dynamic>>' é o formato padrão em Dart para
  // representar os resultados de um SELECT (uma lista de linhas,
  // onde cada linha é um mapa de "coluna": "valor").
  Future<List<Map<String, dynamic>>> query(String sql,
      [List<dynamic>? params]) async {
    // LÓGICA: Linha de debug comentada.
    // print('Consultando SQL: $sql com params: $params');

    // LÓGICA: Retorna uma lista vazia '[]' para simular uma consulta
    // que não encontrou nenhum dado.
    return [];
  }
} // POO: Fim da definição da classe.
