# Como provisionar o cluster Kubernetes com Terraform

Este diretório contém um script Terraform para provisionar um cluster Kubernetes na DigitalOcean.

## Pré-requisitos

- **Conta na DigitalOcean:** Você precisa de uma conta ativa.
- **Token de API da DigitalOcean:** Crie um token de API com permissões de leitura e escrita.
- **Terraform Instalado:** Certifique-se de que o Terraform está instalado em sua máquina.

## Como Utilizar o Script Terraform

Siga estes passos para provisionar seu cluster:

1. **Navegue até o diretório do projeto:**
   Abra seu terminal e mude para o diretório onde o arquivo `main.tf` foi criado.
   ```bash
   cd /home/paragao/devops/fullnews
   ```

2. **Crie um arquivo de variáveis:**
   Crie um arquivo chamado `terraform.tfvars` e adicione seu token da DigitalOcean:
   ```hcl
   do_token = "SEU_TOKEN_DE_API_AQUI"
   ```
   *Substitua `SEU_TOKEN_DE_API_AQUI` pelo seu token real.*

3. **Inicialize o Terraform:**
   Este comando inicializa o diretório de trabalho, baixando o provedor da DigitalOcean.
   ```bash
   terraform init
   ```

4. **Planeje a Infraestrutura:**
   O Terraform criará um plano de execução para você revisar.
   ```bash
   terraform plan
   ```

5. **Aplique as Alterações:**
   Este comando aplicará o plano e criará os recursos na sua conta da DigitalOcean.
   ```bash
   terraform apply
   ```
   Você precisará confirmar a ação digitando `yes` quando solicitado.

## Acessando o Cluster

Após a conclusão, o Terraform exibirá os outputs, incluindo o ID do cluster. O `kube_config` é marcado como sensível, então para salvá-lo em um arquivo e usá-lo com o `kubectl`, execute:

```bash
terraform output -raw kube_config > kubeconfig.yaml
export KUBECONFIG=$(pwd)/kubeconfig.yaml
kubectl get nodes
```

Com isso, seu cluster estará no ar e pronto para ser usado.