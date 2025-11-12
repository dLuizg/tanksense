# TankSense - Sistema de Monitoramento de Tanques

Sistema completo desenvolvido em Dart para monitoramento inteligente de tanques industriais, com integração entre sensores físicos, banco de dados MySQL e interface de gestão.

## 📋 Pré-requisitos

### 1. Protótipo Físico (Hardware)
É **necessário** utilizar um protótipo físico programado em linguagem C com as seguintes especificações:

- **Microcontrolador**: ESP32 ou similar
- **Sensores**: Ultrassônico (HC-SR04) para medição de nível
- **Comunicação**: Wi-Fi para envio de dados
- **Linguagem**: C/C++ (Arduino Framework)
- **Funcionalidades**:
  - Leitura contínua de sensores
  - Cálculo de nível e porcentagem
  - Envio de dados para Firebase Realtime Database
  - Gestão de conexão de rede

### 2. Banco de Dados
O sistema requer um banco de dados MySQL com a estrutura específica do TankSense.

**📁 Estrutura do Banco de Dados:**
[Link para download do banco de dados](https://drive.google.com/drive/folders/1boGAz1gOadWonlMCtYqtITNkeIaC2rZ0?usp=sharing)

*Coloque o link real do seu arquivo do banco de dados acima*

## 🚀 Instalação e Configuração

### 1. Clonar e Configurar o Projeto

```bash
# Para Clonar o Repositório:
# 1. Crie uma pasta vazia em seu computador
# 2. Abra o git bash
# 3. Use a sequência de códigos a seguir
  git init
  git clone [(https://github.com/dLuizg/tanksense.git)]

# 4. Abra a pasta no VS Code e execute os seguintes códigos
  cd tanksense
  dart pub get
```

### 2. Configurar Banco de Dados

1. **Importar a Estrutura**: 
   - Execute o arquivo SQL baixado no seu servidor MySQL
   - Ou restaure o backup fornecido

2. **Configurar Conexão**:
   Edite `lib/database/database_config.dart`:
   ```dart
   final DatabaseConfig databaseConfig = DatabaseConfig(
     host: 'localhost',      // Seu host MySQL
     porta: 3306,            // Porta MySQL
     usuario: 'root',        // Usuário MySQL
     senha: 'sua_senha',     // Senha MySQL
     dbName: 'tanksense',    // Nome do banco
   );
   ```

### 3. Configurar Firebase (Opcional)

Para sincronização com sensores físicos:

```dart
// Em lib/services/leitura_service.dart
static const String baseUrl = 'seu-projeto.firebaseio.com';
static const String authToken = 'seu-token-firebase';
```

## 🎯 Como Usar

### Execução do Sistema

```bash
dart run bin/main.dart
```

### Fluxo de Operação

1. **Inicialização**:
   - Sistema conecta ao banco MySQL
   - Verifica/cria estrutura de tabelas
   - Inicializa serviços

2. **Menu Principal** - Opções disponíveis:

```
==================== MENU PRINCIPAL ====================

1 - 🏭 Empresas          # Cadastro de empresas
2 - 🏠 Locais            # Gestão de locais físicos
3 - ⚙️ Dispositivos      # Configuração de hardware
4 - 📡 Sensores          # Gestão de sensores
5 - 🛢️ Tanques          # Configuração de tanques
6 - 👤 Usuários          # Gestão de usuários
7 - 📜 Leituras          # Sincronização e consulta
8 - ✏️ Produção          # Relatórios de produção

0 - ✖️ Sair
```

### 3. Cadastro Sequencial (Recomendado)

Siga esta ordem para cadastro completo:

1. **🏭 Empresa** → 2. **🏠 Local** → 3. **⚙️ Dispositivo** → 4. **📡 Sensor** → 5. **🛢️ Tanque**

### 4. Sincronização com Sensores Físicos

No menu **Leituras (Opção 7)**:
- **Sincronizar Leituras**: Busca dados do Firebase dos sensores
- **Processar Produção**: Gera relatórios baseados nas leituras
- **Listar Leituras**: Mostra histórico armazenado

## 🏗️ Estrutura do Projeto

```
tanksense/
├── bin/main.dart                 # Ponto de entrada
├── lib/
│   ├── controllers/              # Lógica de controle
│   ├── models/                   # Entidades e modelos
│   ├── services/                 # Regras de negócio
│   ├── dao/                      # Acesso a dados
│   └── database/                 # Configuração DB
└── pubspec.yaml                 # Dependências
```

## 🔧 Funcionalidades Principais

### Gestão Organizacional
- Cadastro de empresas e locais
- Hierarquia empresa → local → tanque
- Gestão de usuários com perfis

### Monitoramento em Tempo Real
- Leitura contínua de sensores
- Cálculo automático de níveis
- Status de tanques (Cheio, Normal, Baixo)

### Produção e Relatórios
- Cálculo de produção diária
- Relatórios por período
- Histórico de leituras

### Integração Hardware-Software
- Comunicação com protótipos físicos
- Sincronização Firebase → MySQL
- Processamento automático de dados

## 🛠️ Desenvolvimento

### Para Desenvolvedores

**Arquitetura Utilizada:**
- **MVC Pattern** (Model-View-Controller)
- **DAO Pattern** para acesso a dados
- **Service Locator** para injeção de dependência
- **POO** com herança e polimorfismo

**Princípios Aplicados:**
- SRP (Single Responsibility Principle)
- Injeção de Dependências
- Separação de Concerns

### Extensões Possíveis

1. **Dashboard Web** - Interface gráfica
2. **Alertas por Email** - Notificações automáticas
3. **API REST** - Integração com outros sistemas
4. **App Mobile** - Monitoramento mobile

## ❗ Troubleshooting

### Problemas Comuns

1. **Erro de Conexão MySQL**:
   - Verifique credenciais no `database_config.dart`
   - Confirme se o serviço MySQL está rodando

2. **Firebase Não Conecta**:
   - Verifique URL e token no `leitura_service.dart`
   - Confirme permissões no Firebase

3. **Estrutura de Tabelas**:
   - Execute `DatabaseSetup.criarTabelasBase()` se necessário

## 📞 Suporte

Para issues e dúvidas:
1. Verifique se todos os pré-requisitos estão atendidos
2. Confirme a configuração do banco de dados
3. Verifique a comunicação com o hardware
4. Caso o erro persistir nos contate via e-mail

henrique.molinari@sou.unifeob.edu.br
luiz.g.diniz@sou.unifeob.edu.br
matteo.bonvento@sou.unifeob.edu.br
nicolas.victorio@sou.unifeob.edu.br

## Integrantes Do Projeto

Henrique de Oliveira Molinari        | RA: 25001176
Luiz Gustavo Paliares Diniz          | RA: 25001239
Matteo Enrico Ferri Bonvento         | RA: 25000081
Nicolas Victorio Buciolli De Souza   | RA: 25000408
---

**⚠️ Nota**: Este sistema requer a integração com o protótipo físico para funcionamento completo. Sem o hardware, apenas as funcionalidades de gestão estarão disponíveis.
