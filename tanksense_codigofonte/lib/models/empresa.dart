// lib/models/empresa.dart
import 'entidade_base.dart';

// POO: Classe Empresa que herda de EntidadeBase
// Representa uma entidade empresarial do domínio do sistema
class Empresa extends EntidadeBase {
  String nome;
  String cnpj;
  final List<String> _departamentos = [];

  // POO: Construtor padrão que inicializa os atributos da empresa
  Empresa(super.id, this.nome, this.cnpj);

  // POO: Factory constructor para criar objetos a partir de mapas
  // LÓGICA: Útil para desserialização de dados do banco ou APIs
  factory Empresa.fromMap(Map<String, dynamic> map) {
    return Empresa(
      map['idEmpresa'] ?? 0,
      map['nome'] ?? '',
      map['cnpj'] ?? '',
    );
  }

  // POO: Getter que retorna uma cópia imutável da lista de departamentos
  List<String> get departamentos => List.unmodifiable(_departamentos);

  // POO: Implementação do método abstrato para exibir dados específicos da empresa
  @override
  void exibirDados() {
    print('🏢 DADOS DA EMPRESA');
    print('─' * 30);
    print('ID: $id');
    print('Nome: $nome');
    print('CNPJ: $cnpj');
    print('Departamentos: ${_departamentos.length}');
    print('Tipo: ${obterTipo()}');
    print('─' * 30);
  }

  // POO: Implementação do método abstrato que define o tipo da entidade
  @override
  String obterTipo() {
    return "Empresa Industrial";
  }

  // LÓGICA: Método para adicionar múltiplos departamentos evitando duplicatas
  void adicionarDepartamentos(List<String> novosDepartamentos) {
    for (String depto in novosDepartamentos) {
      if (!_departamentos.contains(depto)) {
        _departamentos.add(depto);
        print('✅ Departamento adicionado: $depto');
      }
    }
  }

  // POO: Implementação do método para conversão do objeto em mapa
  // LÓGICA: Prepara os dados para persistência ou serialização
  @override
  Map<String, dynamic> toMap() {
    return {
      'idEmpresa': id,
      'nome': nome,
      'cnpj': cnpj,
    };
  }
}