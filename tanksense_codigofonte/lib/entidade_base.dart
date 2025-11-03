// lib/entidade_base.dart

abstract class EntidadeBase {
  final int id;
  EntidadeBase(this.id);

  Map<String, dynamic> toMap();
  void exibirDados();
  String obterTipo();

  @override
  String toString() => toMap().toString();
}