// lib/models/entidade_base.dart

// POO: Classe abstrata que define a interface comum para todas as entidades do sistema
// Serve como contrato base que todas as entidades devem implementar
abstract class EntidadeBase {
  final int id;
  
  // POO: Construtor que garante que toda entidade tenha um ID
  // O ID é final para garantir imutabilidade após a criação
  EntidadeBase(this.id);

  // POO: Método abstrato para serialização - deve ser implementado pelas classes filhas
  // LÓGICA: Converte o objeto em formato Map para persistência ou transferência
  Map<String, dynamic> toMap();

  // POO: Método abstrato para exibição de dados - implementação específica por entidade
  // LÓGICA: Cada entidade define como exibir suas informações de forma personalizada
  void exibirDados();

  // POO: Método abstrato para identificar o tipo da entidade
  // LÓGICA: Retorna uma string descritiva do tipo de entidade
  String obterTipo();

  // POO: Sobrescrita do método toString usando composição funcional
  // LÓGICA: Reutiliza o método toMap() para gerar representação textual padrão
  @override
  String toString() => toMap().toString();
}