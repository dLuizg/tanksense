// lib/models/local.dart
import 'entidade_base.dart';

// POO: Classe Local que herda de EntidadeBase
// Representa um local físico onde os tanques estão instalados
class Local extends EntidadeBase {
  String nome;
  String referencia;
  int empresaId;

  // POO: Construtor que inicializa todos os atributos do local
  Local(super.id, this.nome, this.referencia, this.empresaId);

  // --- INÍCIO DA CORREÇÃO (Bug do Crash 'Null') ---
  // POO: Factory constructor para criação de objetos a partir de mapas
  // LÓGICA: Converte dados do banco para objetos Dart com tratamento de nulos
  factory Local.fromMap(Map<String, dynamic> map) {
    return Local(
      map['idLocal'] as int,
      map['nome'] as String,
      map['referencia'] as String,

      // CORREÇÃO: Tratamento robusto para valores nulos do banco
      // LÓGICA: Usa operador de coalescência nula para evitar crashes
      // 1. (as int?) Tenta converter para um int *anulável*.
      // 2. (?? 0) Se o resultado for 'null', usa 0 como padrão.
      (map['empresa_idEmpresa'] as int?) ?? 0,
    );
  }
  // --- FIM DA CORREÇÃO ---

  // POO: Implementação do método abstrato para exibição dos dados
  @override
  void exibirDados() {
    print(
        '🏠 Local ID: $id | Nome: $nome | Ref: $referencia | Empresa: $empresaId');
  }

  // POO: Implementação do método abstrato para identificar o tipo de entidade
  @override
  String obterTipo() => "Local de Produção";

  // POO: Implementação do método para serialização em mapa
  // LÓGICA: Prepara os dados para persistência no banco de dados
  @override
  Map<String, dynamic> toMap() {
    // Este método é usado para enviar dados para o banco.
    // (Diferente do fromMap, que é para ler do banco)
    return {
      'idLocal': id,
      'nome': nome,
      'referencia': referencia,
      'empresaId': empresaId,
    };
  }
}