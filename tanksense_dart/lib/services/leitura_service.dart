// lib/services/leitura_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/leitura.dart';
import '../models/database_connection.dart';
import '../dao/leitura_dao.dart';

class LeituraService {
  // ... (Configurações do Firebase - sem mudanças) ...
  static const String baseUrl = 'tanksense---v2-default-rtdb.firebaseio.com';
  static const String authToken = 'XALK5M3Yuc7jQgS62iDXpnAKvsBJEWKij0hR02tx';

  final LeituraDao _dao;
  LeituraService(DatabaseConnection db) : _dao = LeituraDao(db);
  LeituraService.fromDao(this._dao);

  /// Busca todas as leituras do banco local
  Future<List<Leitura>> listarBanco() async {
    return await _dao.fetchAll();
  }

  /// Salva uma lista de novas leituras no banco
  Future<int> enviarNovasParaBanco(List<Leitura> novas, int sensorId) async {
    // --- INÍCIO DA MODIFICAÇÃO (POO) ---
    // CORREÇÃO (RangeError): Adiciona validação da chave estrangeira.
    // O Service DEVE proteger o DAO de dados inválidos.
    if (sensorId <= 0) {
      throw ArgumentError('A ID do sensor associado é inválida.');
    }
    if (novas.isEmpty) {
      return 0; // Nada a fazer
    }
    // --- FIM DA MODIFICAÇÃO ---

    return await _dao.insertMany(novas, sensorId);
  }

  /// Carrega leituras da fonte externa (Firebase)
  /// (Este método está correto, é pura lógica de dados/negócio)
  Future<List<Leitura>> carregarDoFirebase(
      String baseUrl, String authToken) async {
    final leituras = <Leitura>[];
    try {
      final url = Uri.https(baseUrl, 'leituras.json', {'auth': authToken});
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data == null) return leituras;
        // ... (resto da lógica de parsing - sem mudanças) ...
        if (data is List) {
          for (int i = 0; i < data.length; i++) {
            final item = data[i];
            if (item == null) continue;
            if (item is Map) {
              final mapData = Map<String, dynamic>.from(item);
              final leitura = Leitura.fromFirebase(mapData, i.toString());
              if (leitura.isValid) leituras.add(leitura);
            }
          }
        } else if (data is Map) {
          data.forEach((key, value) {
            if (value == null) return;
            if (value is Map) {
              final mapData = Map<String, dynamic>.from(value);
              final leitura = Leitura.fromFirebase(mapData, key);
              if (leitura.isValid) leituras.add(leitura);
            }
          });
        }
        leituras.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      } else {
        print('❌ Erro HTTP ${response.statusCode} ao ler Firebase');
      }
    } catch (e) {
      print('❌ Erro ao carregar leituras do Firebase: $e');
    }
    return leituras;
  }

  /* ❌ MÉTODOS REMOVIDOS (Violação do SRP)
     A lógica de 'atualizarLeituras' já está (corretamente) no DataController.
     A lógica de 'listarLeituras' deve estar no Menu (View), que chama o
     Controller, que por sua vez chama o Service.

  Future<void> atualizarLeituras() async {
    // ... (Lógica de print e sensorId=1 movida)
  }

  Future<void> listarLeituras() async {
    // ... (Lógica de print e formatação movida)
  }
  */
}
