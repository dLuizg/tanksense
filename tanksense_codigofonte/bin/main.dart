// bin/main.dart
import 'package:tanksense/database_config.dart';
import 'package:tanksense/database_connection.dart';
import 'package:tanksense/service_locator.dart';
import 'package:tanksense/menu.dart';
import 'package:tanksense/database_setup.dart'; // <-- 1. IMPORTE A NOVA CLASSE

Future<void> main() async {
  final db = DatabaseConnection(databaseConfig);
  await db.connect();

  // --- INÍCIO DA CORREÇÃO ---
  // A lógica de criar tabelas agora está na sua própria classe (SRP)
  final setup = DatabaseSetup(db);
  await setup.criarTabelasBase();
  // --- FIM DA CORREÇÃO ---

  // Inicializa os DAOs e Services
  await ServiceLocator().init(db);

  final menu = Menu();
  await menu.iniciar();
}
