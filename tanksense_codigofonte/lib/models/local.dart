// lib/local.dart
import 'entidade_base.dart';

class Local extends EntidadeBase {
  String nome;
  String referencia;
  int empresaId;

  Local(super.id, this.nome, this.referencia, this.empresaId);

  // --- INÍCIO DA CORREÇÃO (Bug do Crash 'Null') ---
  factory Local.fromMap(Map<String, dynamic> map) {
    return Local(
      map['idLocal'] as int,
      map['nome'] as String,
      map['referencia'] as String,

      // CORREÇÃO:
      // Usamos (map['...'] as int?) ?? 0
      // 1. (as int?) Tenta converter para um int *anulável*.
      // 2. (?? 0) Se o resultado for 'null', usa 0 como padrão.
      (map['empresa_idEmpresa'] as int?) ?? 0,
    );
  }
  // --- FIM DA CORREÇÃO ---

  @override
  void exibirDados() {
    print(
        '🏠 Local ID: $id | Nome: $nome | Ref: $referencia | Empresa: $empresaId');
  }

  @override
  String obterTipo() => "Local de Produção";

  @override
  Map<String, dynamic> toMap() {
    // Este método é usado para *enviar* dados para o banco.
    // (Diferente do fromMap, que é para *ler* do banco)
    return {
      'idLocal': id,
      'nome': nome,
      'referencia': referencia,
      'empresaId': empresaId,
    };
  }
}
