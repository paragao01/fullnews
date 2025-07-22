# Kubenews

Uma aplicação de notícias desenvolvida em NodeJS para demonstrar o uso de containers, Kubernetes e práticas de DevOps.

## 📋 Sobre o Projeto

O projeto Kubenews é uma aplicação web simples desenvolvida em Node.js, projetada como exemplo para demonstrar um fluxo de trabalho completo de DevOps, desde o desenvolvimento local com Docker até o deploy contínuo em um cluster Kubernetes.

## 🏗️ Arquitetura do Projeto

O diagrama abaixo ilustra o fluxo de trabalho, desde o desenvolvimento local até o deploy contínuo no cluster Kubernetes na Digital Ocean.

```
┌───────────────────┐      ┌─────────────────┐      ┌──────────────────┐
│   Desenvolvedor   │──────►   GitHub        ├──────►   Docker Hub     │
│ (VS Code, Docker) │      │ (Push no código)│      │ (Registro da Imagem) │
└───────────────────┘      └───────┬─────────┘      └──────────┬───────┘
                                   │                          │
                                   │ (GitHub Actions CI/CD)   │ (Pull da Imagem)
                                   ▼                          ▼
                  ┌───────────────────────────────────────────────────┐
                  │             Digital Ocean Kubernetes Cluster      │
                  │                                                   │
                  │   ┌──────────┐      ┌─────────────┐     ┌─────────┐
                  │   │ Ingress  ├─────►│  Kubenews   │────►│  PostgreSQL │
                  │   │ (NGINX)  │      │   Pod(s)    │     │ (Banco de Dados)│
                  │   └──────────┘      └──────┬──────┘     └─────────┘
                  │                          │                        │
                  │                          │ (Exporta Métricas)     │
                  │                          ▼                        │
                  │   ┌──────────┐      ┌─────────────┐               │
                  │   │ Prometheus ├─────►│   Grafana   │               │
                  │   │ (Coleta)   │      │ (Visualização)│               │
                  │   └──────────┘      └─────────────┘               │
                  │                                                   │
                  └───────────────────────────────────────────────────┘
```

### 🚀 Funcionalidades Principais

- Listagem de notícias na página inicial
- Criação de novas notícias através de formulário
- Visualização detalhada de cada notícia
- API REST para inserção em massa de notícias
- Endpoints de health check para monitoramento
- Coleta de métricas para Prometheus

### 🛠️ Tecnologias Utilizadas

- **Backend**: Node.js com Express.js
- **Frontend**: EJS (Embedded JavaScript) como motor de templates
- **Banco de Dados**: PostgreSQL com Sequelize ORM
- **Containerização**: Docker
- **Orquestração**: Kubernetes e Docker Compose
- **CI/CD**: GitHub Actions
- **Monitoramento**: Prometheus e Grafana

## 📦 Estrutura do Projeto

```
/
├── .github/                  # Workflows de CI/CD com GitHub Actions
│   └── workflows/
│       └── main.yml
├── dashboards/               # Dashboards de monitoramento
│   └── 11159_rev1.json       # Dashboard para Grafana
├── k8s/                      # Manifestos de deploy do Kubernetes
│   ├── deployment.yaml
│   ├── nginx.yaml
│   └── prometheus_grafana.yaml
├── src/                      # Código-fonte principal da aplicação Node.js
│   ├── models/
│   ├── static/
│   ├── views/
│   ├── .dockerignore
│   ├── Dockerfile
│   ├── middleware.js
│   ├── package.json
│   ├── server.js
│   └── system-life.js
├── .gitignore
├── compose.yaml              # Orquestração local com Docker Compose
├── popula-dados.http         # Requisições de exemplo para popular o banco
└── README.md                 # Documentação do projeto
```

## 🚀 Ambientes de Execução

Existem duas formas principais de executar esta aplicação, cada uma adequada a um cenário diferente.

### 1. Ambiente de Desenvolvimento Local (com Docker Compose)

Para desenvolver e testar na sua máquina local. Este método sobe a aplicação e o banco de dados de forma rápida e integrada.

1.  **Pré-requisitos:**
    *   Docker
    *   Docker Compose

2.  **Inicie os serviços:**
    Na raiz do projeto, execute:
    ```bash
    docker-compose up -d
    ```

3.  **Acesse a aplicação:**
    A aplicação estará disponível em [http://localhost:8080](http://localhost:8080).

4.  **Para parar os serviços:**
    ```bash
    docker-compose down
    ```

### 2. Ambiente de Produção/Staging (com Kubernetes)

Para realizar o deploy da aplicação em um cluster Kubernetes, como o da Digital Ocean.

1.  **Pré-requisitos:**
    *   Um cluster Kubernetes acessível.
    *   `kubectl` configurado para acessar seu cluster.

2.  **Aplicar os manifestos:**
    Os manifestos na pasta `k8s/` contêm todos os recursos necessários (Deployments, Services, Ingress, etc.). Para aplicá-los, execute:
    ```bash
    kubectl apply -f k8s/
    ```

3.  **Acessar a aplicação no cluster:**
    Após o deploy, a aplicação estará acessível através do Ingress. Verifique o endereço de acesso com:
    ```bash
    kubectl get ingress
    ```

## 🔧 Configuração

### Variáveis de Ambiente

Para configurar a aplicação, defina as seguintes variáveis de ambiente. Ao usar o `compose.yaml`, elas já são injetadas a partir do arquivo.

| Variável | Descrição | Valor Padrão |
|----------|-----------|--------------|
| DB_DATABASE | Nome do banco de dados | kubedevnews |
| DB_USERNAME | Usuário do banco de dados | kubedevnews |
| DB_PASSWORD | Senha do usuário | Pg#123 |
| DB_HOST | Endereço do banco de dados | localhost |
| DB_PORT | Porta do banco de dados | 5432 |
| DB_SSL_REQUIRE | Habilitar SSL para conexão | false |

## 🔄 Pipeline de CI/CD

Este projeto utiliza GitHub Actions para automação de CI/CD. O workflow está definido em `.github/workflows/main.yml` e é acionado a cada `push` na branch `main`.

**Continuous Integration (CI):**
1.  **Login no Docker Hub:** Autentica no registro de contêineres.
2.  **Build e Push da Imagem:** Compila a imagem Docker da aplicação e a envia para o Docker Hub com as tags `latest` e a identificação do commit.

**Continuous Deployment (CD):**
1.  **Deploy na Digital Ocean:** Após a imagem ser publicada, o pipeline se conecta ao cluster Kubernetes na Digital Ocean e atualiza o Deployment da aplicação para utilizar a nova imagem, realizando o deploy de forma automática.

## 📊 Monitoramento e Health Checks

A aplicação disponibiliza endpoints para monitoramento e também recursos para simular cenários de falha, muito úteis para testar a resiliência em ambientes Kubernetes.

### Endpoints de Monitoramento
- `/health` - Verifica o estado atual da aplicação.
- `/ready` - Verifica se a aplicação está pronta para receber tráfego.
- `/metrics` - Métricas do Prometheus.

### Simulação de Falhas (Chaos Engineering)
- `/unhealth` - (PUT) Altera o estado da aplicação para não saudável.
- `/unreadyfor/:seconds` - (PUT) Simula indisponibilidade temporária.

### Visualizando Métricas no Grafana

O projeto inclui um manifesto para deploy do Grafana e um dashboard pré-configurado.

1.  **Acessar o Grafana:** O serviço do Grafana é exposto pelo Kubernetes. Encontre o endereço de acesso e a porta.
2.  **Importar o Dashboard:**
    *   Acesse a interface do Grafana.
    *   Navegue até `Dashboards` -> `Import`.
    *   Faça o upload ou copie o conteúdo do arquivo `dashboards/11159_rev1.json`.
    *   Adicione o Prometheus como fonte de dados (DataSource) se necessário.

## 🔒 Modelo de Dados

O projeto utiliza um único modelo `Post` com os seguintes campos:

| Campo | Tipo | Descrição |
|-------|------|-----------|
| title | String | Título da notícia |
| summary | String | Resumo da notícia |
| content | String | Conteúdo completo |
| publishDate | Date | Data de publicação |

## Outras Formas de Execução

### Execução Local (via NPM)

Se preferir não usar Docker, você pode executar a aplicação diretamente com Node.js.

1. Clone o repositório
2. Instale as dependências:
   ```bash
   cd src
   npm install
   ```
3. Configure as variáveis de ambiente e um banco de dados PostgreSQL.
4. Inicie a aplicação:
   ```bash
   npm start
   ```
5. Acesse a aplicação em [http://localhost:8080](http://localhost:8080)

### População de Dados de Exemplo

Utilize o arquivo `popula-dados.http` com uma ferramenta como o REST Client (extensão do VS Code) ou `curl` para inserir notícias de exemplo.