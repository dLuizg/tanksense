// lib/models/env_config.dart

import 'dart:io';

// POO: Classe responsável por gerenciar configurações de ambiente
// Segrega a responsabilidade de carregar e armazenar variáveis de ambiente
class EnvConfig {
  // POO: Atributos para armazenar configurações de diferentes serviços
  String firebaseUrl = '';
  String firebaseToken = '';
  String mysqlHost = 'localhost';
  int mysqlPort = 3306;
  String mysqlUser = 'root';
  String mysqlPassword = '';
  String mysqlDatabase = 'tanksense';

  // POO: Getter computado que verifica se a configuração MySQL está completa
  // LÓGICA: Valida se os campos essenciais para conexão MySQL estão preenchidos
  bool get isMySQLConfigured =>
      mysqlHost.isNotEmpty && mysqlUser.isNotEmpty && mysqlDatabase.isNotEmpty;

  // LÓGICA: Método assíncrono para carregar configurações do arquivo .env
  // Processa linha por linha e atribui valores aos campos correspondentes
  Future<void> load() async {
    final envFile = File('.env');
    if (!await envFile.exists()) {
      print('⚠️ Arquivo .env não encontrado. Usando configurações padrão.');
      return;
    }

    final lines = await envFile.readAsLines();
    for (final line in lines) {
      // LÓGICA: Ignora linhas vazias e comentários no arquivo .env
      if (line.trim().isEmpty || line.startsWith('#')) continue;
      
      // LÓGICA: Divide cada linha em chave=valor e processa os pares
      final parts = line.split('=');
      if (parts.length == 2) {
        final key = parts[0].trim();
        final value = parts[1].trim();
        
        // LÓGICA: Switch para mapear cada variável de ambiente ao campo correspondente
        switch (key) {
          case 'FIREBASE_URL':
            firebaseUrl = value;
            break;
          case 'FIREBASE_TOKEN':
            firebaseToken = value;
            break;
          case 'MYSQL_HOST':
            mysqlHost = value;
            break;
          case 'MYSQL_PORT':
            mysqlPort = int.tryParse(value) ?? mysqlPort;
            break;
          case 'MYSQL_USER':
            mysqlUser = value;
            break;
          case 'MYSQL_PASSWORD':
            mysqlPassword = value;
            break;
          case 'MYSQL_DATABASE':
            mysqlDatabase = value;
            break;
        }
      }
    }
  }

  // LÓGICA: Método para exibir todas as configurações de forma organizada
  // Mostra valores sensíveis de forma mascarada para segurança
  void exibirConfiguracoes() {
    print('\n📁 CONFIGURAÇÕES CARREGADAS DO .env');
    print('─' * 40);
    print(
        '🔥 Firebase URL: ${firebaseUrl.isEmpty ? 'Não configurado' : firebaseUrl}');
    print(
        '🔑 Firebase Token: ${firebaseToken.isEmpty ? 'Não configurado' : '••••••'}');
    print('🗃️ MySQL Host: $mysqlHost');
    print('🚪 MySQL Porta: $mysqlPort');
    print('👤 MySQL Usuário: $mysqlUser');
    print(
        '🔑 MySQL Senha: ${mysqlPassword.isEmpty ? 'Não configurada' : '••••••'}');
    print('🗃️ MySQL Database: $mysqlDatabase');
    print('─' * 40);
  }
}