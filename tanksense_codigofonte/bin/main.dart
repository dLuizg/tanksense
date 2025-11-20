// bin/main.dart

import 'package:tanksense/dao/database/database_config.dart';
import 'package:tanksense/dao/database/database_connection.dart';
import 'package:tanksense/core/di/service_locator.dart';
import 'package:tanksense/view/menu.dart';
import 'package:tanksense/dao/database/database_setup.dart';

// Ponto de entrada principal da aplicação - função assíncrona
Future<void> main() async {
  // Cria uma instância de conexão com o banco de dados usando configurações pré-definidas
  final db = DatabaseConnection(databaseConfig);
  // Estabelece a conexão física com o banco de dados (operações de I/O)
  await db.connect();

  // POO: Princípio da Responsabilidade Única - classe dedicada apenas para setup do banco
  // Cria uma instância especializada apenas para configuração do esquema do banco
  final setup = DatabaseSetup(db);
  // Executa a criação das tabelas necessárias para a aplicação funcionar
  // LÓGICA: Garante que a estrutura do banco existe antes de qualquer operação
  await setup.criarTabelasBase();

  // POO: Padrão de Injeção de Dependência com Service Locator
  // Inicializa todos os serviços e DAOs da aplicação em um container central
  // LÓGICA: Configura dependências antes do uso, seguindo o princípio de inversão de controle
  await ServiceLocator().init(db);

  // POO: Instancia o menu principal que controla o fluxo da aplicação
  // Cria o objeto menu que gerencia a interface com o usuário
  final menu = Menu();
  // Inicia o loop principal do programa, aguardando interações do usuário
  await menu.iniciar();
}