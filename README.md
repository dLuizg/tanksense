# TankSense - Sistema de Monitoramento de Tanques

Sistema completo desenvolvido em Dart para monitoramento inteligente de tanques industriais, seguindo arquitetura MVC com integração entre sensores físicos, banco de dados MySQL e interface de gestão (PowerBI).

## 🏗️ Arquitetura do Sistema

### Estrutura MVC Implementada

```
tanksense/
├── bin/
│   └── main.dart                 # Ponto de entrada da aplicação
├── lib/
│   ├── core/                     # Componentes transversais
│   │   ├── config/
│   │   │   └── env_config.dart   # Configurações de ambiente
│   │   └── di/
│   │       └── service_locator.dart  # Injeção de dependências
│   ├── models/                   # Camada de Modelos (Entidades)
│   │   ├── dispositivo.dart      # Entidade Dispositivo
│   │   ├── empresa.dart          # Entidade Empresa
│   │   ├── entidade_base.dart    # Classe base para entidades
│   │   ├── leitura.dart          # Entidade Leitura
│   │   ├── local.dart            # Entidade Local
│   │   ├── perfil_usuario.dart   # Classe utilitária
│   │   ├── producao.dart         # Entidade Produção
│   │   ├── sensor.dart           # Entidade Sensor
│   │   ├── tanque.dart           # Entidade Tanque
│   │   └── usuario.dart          # Entidade Usuário
│   ├── controllers/              # Camada de Controladores
│   │   ├── consulta_controller.dart
│   │   ├── data_controller.dart
│   │   ├── gestao_equipamentos_controller.dart
│   │   ├── gestao_organizacional_controller.dart
│   │   ├── leitura_controller.dart
│   │   └── producao_controller.dart
│   ├── services/                 # Camada de Serviços (Lógica de Negócio)
│   │   ├── dispositivo_service.dart
│   │   ├── empresa_service.dart
│   │   ├── entidade_service.dart
│   │   ├── leitura_service.dart
│   │   ├── local_service.dart
│   │   ├── producao_service.dart
│   │   ├── sensor_service.dart
│   │   ├── tanque_service.dart
│   │   └── usuario_service.dart
│   ├── dao/                      # Data Access Objects
│   │   ├── database/             # Configuração do banco
│   │   │   ├── database_config.dart
│   │   │   ├── database_connection.dart
│   │   │   └── database_setup.dart
│   │   ├── base_dao.dart         # DAO base com operações genéricas
│   │   ├── dispositivo_dao.dart
│   │   ├── empresa_dao.dart
│   │   ├── leitura_dao.dart
│   │   ├── local_dao.dart
│   │   ├── producao_dao.dart
│   │   ├── sensor_dao.dart
│   │   ├── tanque_dao.dart
│   │   └── usuario_dao.dart
│   └── view/                     # Camada de Visualização
│       └── menu.dart             # Interface principal do usuário
└── pubspec.yaml                  # Dependências do projeto
```

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

## 🚀 Instalação e Configuração

### 1. Clonar e Configurar o Projeto

```bash
# Clonar o repositório
git clone https://github.com/dLuizg/tanksense.git
cd tanksense

# Instalar dependências
dart pub get
```

### 2. Configurar Variáveis de Ambiente

Altere as informações do seu banco na classe `database_config.dart`

```
host: 'seu_local_host',
porta: 3306,
usuario: 'SeuUser',
senha: 'sua_senha',
dbName: 'tanksense',
```
Crie um arquivo `.env` na raiz do projeto:

```env
# Configurações MySQL
MYSQL_HOST=localhost
MYSQL_PORT=3306
MYSQL_USER=root
MYSQL_PASSWORD=sua_senha
MYSQL_DATABASE=tanksense

# Configurações Firebase (Opcional)
FIREBASE_URL=seu-projeto.firebaseio.com
FIREBASE_TOKEN=seu-token-firebase
```

### 3. Configurar Banco de Dados

1. **Importar a Estrutura**: 
   - Execute o arquivo SQL baixado no seu servidor MySQL
   - Ou restaure o backup fornecido

2. **O sistema criará automaticamente** as tabelas necessárias na primeira execução através do `DatabaseSetup`.

## 🎯 Como Usar

### Execução do Sistema

```bash
dart run bin/main.dart
```

### Fluxo de Operação MVC

1. **Inicialização**:
   - Carrega configurações do `.env`
   - Conecta ao banco MySQL
   - Cria estrutura de tabelas (se necessário)
   - Inicializa Service Locator com todas as dependências

2. **Menu Principal** - Interface de usuário:

```
==================== MENU PRINCIPAL ====================

1 - 🏭 Empresas          # Gestão de empresas
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

Siga esta ordem para cadastro completo no sistema:

1. **🏭 Empresa** → 2. **🏠 Local** → 3. **⚙️ Dispositivo** → 4. **📡 Sensor** → 5. **🛢️ Tanque**

### 4. Sincronização com Sensores Físicos

No menu **Leituras (Opção 7)**:
- **Sincronizar Leituras**: Busca dados do Firebase dos sensores físicos
- **Processar Produção**: Gera relatórios baseados nas leituras
- **Listar Leituras**: Mostra histórico armazenado no banco local

## 🔧 Funcionalidades por Camada

### 🎨 View (Apresentação)
- `menu.dart`: Interface de console com usuário
- Navegação entre funcionalidades
- Captura de inputs do usuário

### 🎮 Controllers (Lógica de Apresentação)
- **ConsultaController**: Listagens e consultas
- **DataController**: Sincronização e processamento de dados
- **GestaoOrganizacionalController**: Empresas, locais e usuários
- **GestaoEquipamentosController**: Dispositivos, sensores e tanques
- **ProducaoController**: Relatórios de produção

### 💼 Services (Lógica de Negócio)
- Validações de regras de negócio
- Processamento complexo de dados
- Cálculo de produção a partir de leituras
- Integração com serviços externos (Firebase)

### 📊 DAO (Acesso a Dados)
- Operações CRUD no banco MySQL
- Isolamento da lógica de persistência
- Mapeamento objeto-relacional

### 🗂️ Models (Entidades de Domínio)
- Estruturas de dados do sistema
- Comportamentos específicos de cada entidade
- Validações internas dos dados

### ⚙️ Core (Infraestrutura)
- **Service Locator**: Padrão de injeção de dependência
- **Env Config**: Gestão de configurações de ambiente
- **Database**: Conexão e configuração do banco

## 🛠️ Padrões e Princípios Aplicados

### Arquitetura MVC
- **Separação clara** de responsabilidades
- **Manutenibilidade** e testabilidade
- **Baixo acoplamento** entre camadas

### Princípios SOLID
- **SRP**: Cada classe tem uma única responsabilidade
- **DIP**: Dependências injetadas via Service Locator
- **OCP**: Extensível através de herança e composição

### Padrões de Projeto
- **DAO**: Isolamento do acesso a dados
- **Service Locator**: Injeção de dependências
- **MVC**: Organização arquitetural
- **Repository**: Abstração de persistência

## 🔄 Fluxo de Dados

```
SENSORES FÍSICOS → FIREBASE → LEITURA SERVICE → DAO → BANCO MYSQL
                                 ↓
                         CONTROLLERS → VIEW → USUÁRIO
                                 ↓
                         RELATÓRIOS → PRODUÇÃO SERVICE
```

## ❗ Troubleshooting

### Problemas Comuns

1. **Erro de Conexão MySQL**:
   - Verifique arquivo `.env` e credenciais
   - Confirme se o serviço MySQL está rodando

2. **Firebase Não Conecta**:
   - Verifique URL e token no arquivo `.env`
   - Confirme permissões no Firebase Realtime Database

3. **Estrutura de Tabelas**:
   - O sistema cria automaticamente na primeira execução
   - Verifique logs do `DatabaseSetup`

4. **Dependências não carregadas**:
   - Execute `dart pub get` para baixar dependências
   - Verifique se `mysql1` está no `pubspec.yaml`

## 📞 Suporte

Para issues e dúvidas técnicas:

1. Verifique se todos os pré-requisitos estão atendidos
2. Confirme a configuração do arquivo `.env`
3. Verifique a comunicação com o hardware físico
4. Caso o erro persistir, contate a equipe:

**Integrantes do Projeto:**
- Henrique de Oliveira Molinari - RA: 25001176 - henrique.molinari@sou.unifeob.edu.br
- Luiz Gustavo Paliares Diniz - RA: 25001239 - luiz.g.diniz@sou.unifeob.edu.br  
- Matteo Enrico Ferri Bonvento - RA: 25000081 - matteo.bonvento@sou.unifeob.edu.br
- Nicolas Victorio Buciolli De Souza - RA: 25000408 - nicolas.victorio@sou.unifeob.edu.br

---

**⚠️ Nota**: Este sistema requer a integração com o protótipo físico para funcionamento completo. Sem o hardware, apenas as funcionalidades de gestão administrativa estarão disponíveis.

**🚀 Desenvolvido com Dart seguindo boas práticas de arquitetura MVC e POO.**
