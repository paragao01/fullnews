
# Bloco de configuração do Terraform
terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Variável para o token de API da DigitalOcean
# O token pode ser fornecido através de um arquivo .tfvars ou como uma variável de ambiente.
variable "do_token" {
  description = "Token de API da DigitalOcean."
  type        = string
  sensitive   = true
}

# Configuração do provedor DigitalOcean
# Utiliza a variável do_token para autenticação.
provider "digitalocean" {
  token = var.do_token
}

# Data source para obter a versão estável mais recente do Kubernetes
data "digitalocean_kubernetes_versions" "latest" {
  # Filtra por versões estáveis (ex: 1.28.x)
  version_prefix = "1."
  # Ordena para que a mais recente apareça primeiro
  sort = "desc"
}

# Recurso para criar o cluster Kubernetes (DOKS)
resource "digitalocean_kubernetes_cluster" "k8s_aula" {
  # Nome do cluster
  name   = "k8s-aula"
  # Região onde o cluster será criado
  region = "nyc1"
  # Versão do Kubernetes, obtida dinamicamente do data source
  version = data.digitalocean_kubernetes_versions.latest.latest_version

  # Definição do Node Pool padrão
  node_pool {
    name       = "default-node-pool"
    # Slug para nós de 2 vCPUs, 4GB de RAM e 80GB de disco
    size       = "s-2vcpu-4gb"
    # Quantidade de nós no pool
    node_count = 2
  }
}

# Saída (Output) para o ID do cluster
output "cluster_id" {
  description = "O ID do cluster Kubernetes provisionado."
  value       = digitalocean_kubernetes_cluster.k8s_aula.id
}

# Saída (Output) para o kubeconfig, usado para acessar o cluster com kubectl
output "kube_config" {
  description = "A configuração kubeconfig para acessar o cluster."
  value       = digitalocean_kubernetes_cluster.k8s_aula.kube_config
  sensitive   = true
}
