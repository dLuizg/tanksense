import 'dart:io';

class EnvConfig {
  String firebaseUrl = '';
  String firebaseToken = '';
  String mysqlHost = 'localhost';
  int mysqlPort = 3306;
  String mysqlUser = 'root';
  String mysqlPassword = '';
  String mysqlDatabase = 'tanksense';

  bool get isMySQLConfigured =>
      mysqlHost.isNotEmpty && mysqlUser.isNotEmpty && mysqlDatabase.isNotEmpty;

  Future<void> load() async {
    final envFile = File('.env');
    if (!await envFile.exists()) {
      print('⚠️ Arquivo .env não encontrado. Usando configurações padrão.');
      return;
    }

    final lines = await envFile.readAsLines();
    for (final line in lines) {
      if (line.trim().isEmpty || line.startsWith('#')) continue;
      final parts = line.split('=');
      if (parts.length == 2) {
        final key = parts[0].trim();
        final value = parts[1].trim();
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
