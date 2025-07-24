# Kubenews: Aplicação de Exemplo para DevOps com Kubernetes

## Tecnologias Utilizadas

- **Backend:** Node.js, Express.js
- **Frontend:** EJS (Embedded JavaScript templates)
- **Banco de Dados:** PostgreSQL, Sequelize (ORM)
- **Containerização:** Docker, Docker Compose
- **Orquestração:** Kubernetes
- **Monitoramento:** Prometheus
- **CI/CD:** GitHub Actions
[![Docker Pulls](https://img.shields.io/docker/pulls/USUARIO/kubenews.svg)](https://hub.docker.com/r/USUARIO/kubenews)
[![Licença](https://img.shields.io/badge/licença-MIT-blue.svg)](/LICENSE)

Uma aplicação de notícias completa, desenvolvida em Node.js, para demonstrar um fluxo de trabalho de DevOps, desde o provisionamento da infraestrutura com Terraform até o deploy contínuo em um cluster Kubernetes.

## 📋 Tabela de Conteúdos

- [Sobre o Projeto](#-sobre-o-projeto)
- [Arquitetura](#️-arquitetura)
- [Funcionalidades e Tecnologias](#-funcionalidades-e-tecnologias)
- [🚀 Começando (Execução Local)](#-começando-execução-local)
- [🚢 Fluxo de Deploy (DevOps)](#-fluxo-de-deploy-devops)
  - [Passo 1: Provisionando a Infraestrutura (Terraform)](#passo-1-provisionando-a-infraestrutura-terraform)
  - [Passo 2: Deploy da Aplicação (Kubernetes)](#passo-2-deploy-da-aplicação-kubernetes)
  - [Passo 3: Automação com CI/CD (GitHub Actions)](#passo-3-automação-com-cicd-github-actions)
- [🔧 Configuração](#-configuração)
- [📊 Monitoramento e Observabilidade](#-monitoramento-e-observabilidade)
- [👨‍💻 Desenvolvimento Avançado](#-desenvolvimento-avançado)
- [📂 Estrutura do Projeto](#-estrutura-do-projeto)

## 📖 Sobre o Projeto

O **Kubenews** é uma aplicação web projetada para servir como um exemplo prático de um ciclo de vida de desenvolvimento de software moderno. Ele abrange desde a containerização com Docker, provisionamento de infraestrutura como código (IaC) com Terraform, até a orquestração e o deploy contínuo em um cluster Kubernetes gerenciado.

## 🏗️ Arquitetura

O diagrama abaixo ilustra o fluxo de trabalho completo, desde o desenvolvimento local até o deploy automatizado no cluster Kubernetes.

```
┌───────────────────┐      ┌─────────────────┐      ┌──────────────────────┐
│   Desenvolvedor   │──────►   GitHub        ├──────►   Docker Hub         │
│ (VS Code, Docker) │      │ (Push no código)│      │ (Registro da Imagem) │
└───────────────────┘      └───────┬─────────┘      └──────────┬───────────┘
                                   │                           │
                                   │ (GitHub Actions CI/CD)    │ (Pull da Imagem)
                                   ▼                           ▼
                  ┌────────────────────────────────────────────────────────────┐
                  │          Cloud (Ex: Digital Ocean Kubernetes)              │
                  │                                                            │
                  │   ┌──────────┐      ┌─────────────┐     ┌─────────────────┐│
                  │   │ Ingress  ├─────►│  Kubenews   │────►│  PostgreSQL     ││
                  │   │          │      │   Pod(s)    │     │ (Banco de Dados)││
                  │   └──────────┘      └──────┬──────┘     └─────────────────┘│
                  │                            │                               │
                  │                            │ (Exporta Métricas)            │
                  │                            ▼                               │
                  │   ┌────────────┐      ┌───────────────┐                    │
                  │   │ Prometheus ├─────►│   Grafana     │                    │
                  │   │ (Coleta)   │      │ (Visualização)│                    │
                  │   └────────────┘      └───────────────┘                    │
                  │                                                            │
                  └────────────────────────────────────────────────────────────┘
```

## ✨ Funcionalidades e Tecnologias

| Funcionalidades Principais | Tecnologias Utilizadas |
| -------------------------- | ---------------------- |
| 🔹 Listagem de notícias     | 🔸 **Backend**: Node.js, Express.js |
| 🔹 Criação e edição de posts | 🔸 **Frontend**: EJS (Templates) |
| 🔹 API REST para dados      | 🔸 **Banco de Dados**: PostgreSQL, Sequelize |
| 🔹 Health checks para K8s   | 🔸 **Container**: Docker, Docker Compose |
| 🔹 Métricas para Prometheus | 🔸 **Infraestrutura**: Terraform |
| 🔹 Simulação de falhas     | 🔸 **Orquestração**: Kubernetes |
|                            | 🔸 **CI/CD**: GitHub Actions |
|                            | 🔸 **Monitoramento**: Prometheus, Grafana |

## 🚀 Começando (Execução Local)

Para executar o projeto em seu ambiente de desenvolvimento, a forma mais simples é usando Docker Compose.

**Pré-requisitos:**
*   Docker
*   Docker Compose

**Passos:**
1.  Clone o repositório:
    ```bash
    git clone https://github.com/USUARIO/REPOSITORIO.git
    cd REPOSITORIO
    ```
2.  Inicie os serviços (aplicação e banco de dados):
    ```bash
    docker-compose up -d
    ```
3.  Acesse a aplicação em **[http://localhost:8080](http://localhost:8080)**.

Para parar todos os contêineres, execute `docker-compose down`.

## 🚢 Fluxo de Deploy (DevOps)

Esta seção descreve o processo completo para colocar a aplicação em um ambiente de produção ou staging na nuvem.

### Passo 1: Provisionando a Infraestrutura (Terraform)

Utilizamos o Terraform para criar e gerenciar a infraestrutura como código, garantindo um ambiente replicável e consistente. O código está na pasta `k8s/terraform/`.

**Pré-requisitos:**
*   [Terraform CLI](https://learn.hashicorp.com/tutorials/terraform/install-cli) instalado.
*   Token de acesso de um provedor de nuvem (ex: Digital Ocean) configurado como variável de ambiente.

**Passos:**
1.  Navegue até o diretório do Terraform:
    ```bash
    cd k8s/terraform
    ```
2.  Inicialize o Terraform para baixar os providers:
    ```bash
    terraform init
    ```
3.  (Opcional) Planeje a infraestrutura para revisar as mudanças:
    ```bash
    terraform plan
    ```
4.  Aplique as configurações para criar os recursos na nuvem (ex: cluster Kubernetes):
    ```bash
    terraform apply
    ```
Para destruir a infraestrutura, use `terraform destroy`.

### Passo 2: Deploy da Aplicação (Kubernetes)

Com o cluster provisionado, você pode fazer o deploy da aplicação e de seus componentes de monitoramento.

**Pré-requisitos:**
*   `kubectl` configurado para acessar seu cluster.

**Passos:**
1.  Aplique todos os manifestos do Kubernetes de uma vez:
    ```bash
    kubectl apply -f k8s/
    ```
    Isso criará os Deployments, Services, Ingress e outros recursos necessários.

2.  Verifique o status e obtenha o IP de acesso:
    ```bash
    kubectl get ingress
    ```

### Passo 3: Automação com CI/CD (GitHub Actions)

O pipeline em `.github/workflows/main.yml` automatiza o processo de build e deploy a cada `push` na branch `main`.

*   **Continuous Integration (CI):** O workflow realiza o login no Docker Hub, constrói a imagem da aplicação e a publica no registro com a tag do commit.
*   **Continuous Deployment (CD):** Após a publicação da imagem, o pipeline se conecta ao cluster Kubernetes e atualiza o Deployment para usar a nova imagem, efetivando o deploy de forma automática.

## 🔧 Configuração

A aplicação é configurada através de variáveis de ambiente. O `compose.yaml` e os manifestos do Kubernetes já as injetam.

| Variável | Descrição | Valor Padrão |
|----------|-----------|--------------|
| `DB_DATABASE` | Nome do banco de dados | `kubedevnews` |
| `DB_USERNAME` | Usuário do banco de dados | `kubedevnews` |
| `DB_PASSWORD` | Senha do usuário | `Pg#123` |
| `DB_HOST` | Endereço do banco de dados | `localhost` |
| `DB_PORT` | Porta do banco de dados | `5432` |
| `DB_SSL_REQUIRE` | Habilitar SSL para conexão | `false` |

## 📊 Monitoramento e Observabilidade

A aplicação foi instrumentada para expor métricas e health checks, essenciais em um ambiente orquestrado.

**Endpoints de Monitoramento:**
*   `/health`: Verifica a saúde da aplicação (liveness probe).
*   `/ready`: Verifica se a aplicação está pronta para receber tráfego (readiness probe).
*   `/metrics`: Expõe métricas no formato Prometheus.

**Simulação de Falhas (Chaos Engineering):**
*   `PUT /unhealth`: Altera o estado da aplicação para não saudável.
*   `PUT /unreadyfor/:seconds`: Simula indisponibilidade temporária.

**Visualizando Métricas no Grafana:**
1.  Acesse o Grafana através do Ingress ou port-forward.
2.  Navegue até `Dashboards` -> `Import`.
3.  Faça o upload do arquivo `dashboards/11159_rev1.json` para importar um dashboard pré-configurado.

## 👨‍💻 Desenvolvimento Avançado

### Execução Local via NPM
Se preferir rodar a aplicação sem Docker:
1.  Tenha um banco de dados PostgreSQL acessível.
2.  Configure as variáveis de ambiente listadas acima.
3.  Instale as dependências e inicie:
    ```bash
    cd src
    npm install
    npm start
    ```

### Populando Dados de Exemplo
Use o arquivo `popula-dados.http` com a extensão REST Client do VS Code ou `curl` para popular o banco com notícias de exemplo.

## 📂 Estrutura do Projeto
```
/
├── .github/                  # Workflows de CI/CD com GitHub Actions
├── dashboards/               # Dashboards para Grafana
├── k8s/                      # Recursos do Kubernetes
│   ├── terraform/            # Código de Infraestrutura como Código (IaC)
│   ├── deployment.yaml       # Manifestos da aplicação
│   └── ...
├── src/                      # Código-fonte da aplicação Node.js
├── .gitignore
├── compose.yaml              # Orquestração local com Docker Compose
├── popula-dados.http         # Requisições de exemplo
└── README.md                 # Esta documentação
```