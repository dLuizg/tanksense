// lib/empresa.dart
import 'entidade_base.dart';

class Empresa extends EntidadeBase {
  String nome;
  String cnpj;
  final List<String> _departamentos = [];

  Empresa(super.id, this.nome, this.cnpj);

  factory Empresa.fromMap(Map<String, dynamic> map) {
    return Empresa(
      map['idEmpresa'] ?? 0,
      map['nome'] ?? '',
      map['cnpj'] ?? '',
    );
  }

  List<String> get departamentos => List.unmodifiable(_departamentos);

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

  @override
  String obterTipo() {
    return "Empresa Industrial";
  }

  void adicionarDepartamentos(List<String> novosDepartamentos) {
    for (String depto in novosDepartamentos) {
      if (!_departamentos.contains(depto)) {
        _departamentos.add(depto);
        print('✅ Departamento adicionado: $depto');
      }
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'idEmpresa': id,
      'nome': nome,
      'cnpj': cnpj,
    };
  }
}
