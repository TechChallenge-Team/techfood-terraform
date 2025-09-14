# TechFood Terraform Project

Este projeto cria a infraestrutura AWS para o TechFood usando Terraform, incluindo um cluster EKS e toda a infraestrutura necessária.

## 📋 Pré-requisitos

### 1. Terraform instalado

- Baixe e instale: https://www.terraform.io/downloads
- Verifique: `terraform --version`

### 2. AWS CLI instalado

- Baixe e instale: https://aws.amazon.com/cli/
- Verifique: `aws --version`

## Configuração das Credenciais AWS Academy

### Passo 1: Obter credenciais do AWS Academy

1. Acesse seu laboratório AWS Academy
2. Clique em "AWS Details"
3. Clique em "Show" ao lado de "AWS CLI"
4. Copie as credenciais mostradas

### Passo 2: Configurar as credenciais

#### Opção A: Via arquivo de credenciais (RECOMENDADO)

Crie o arquivo `~/.aws/credentials` (ou `%USERPROFILE%\.aws\credentials` no Windows):

```ini
[default]
aws_access_key_id = SEU_ACCESS_KEY_ID
aws_secret_access_key = SEU_SECRET_ACCESS_KEY
aws_session_token = SEU_SESSION_TOKEN
```

#### Opção B: Via variáveis de ambiente

Execute no PowerShell:

```powershell
$env:AWS_ACCESS_KEY_ID="SEU_ACCESS_KEY_ID"
$env:AWS_SECRET_ACCESS_KEY="SEU_SECRET_ACCESS_KEY"
$env:AWS_SESSION_TOKEN="SEU_SESSION_TOKEN"
```

### Passo 3: Configurar a região

```powershell
aws configure set region us-east-1
```

## Execução do Projeto

### 1. Navegue até o diretório do projeto

```powershell
cd "c:\Users\lc\Desktop\FIAP\tech-challenge\techfood-terraform"
```

### 2. Inicialize o Terraform

```powershell
terraform init
```

### 3. Valide a configuração

```powershell
terraform validate
```

### 4. Planeje a execução (opcional)

```powershell
terraform plan
```

### 5. Aplique a infraestrutura

```powershell
terraform apply
```

Digite `yes` quando solicitado.

## Recursos que serão criados

- **VPC** com 3 subnets públicas
- **Cluster EKS** na versão 1.31
- **Node Group** com instâncias t3.medium
- **Security Groups**
- **Internet Gateway** e rotas
- **Roles IAM** necessários
- **Bucket S3**

## Custos Estimados (AWS Academy)

Como você está usando o AWS Academy, os custos são cobertos pelos créditos do laboratório. Porém, mantenha-se atento aos limites:

- **EKS Control Plane**: ~$0.10/hora
- **EC2 instances (t3.medium)**: ~$0.042/hora por instância
- **Outros recursos**: custos mínimos

## Limpeza dos Recursos

⚠️ **IMPORTANTE**: Sempre destrua os recursos após o uso para economizar créditos:

```powershell
terraform destroy
```

## Troubleshooting

### Erro de credenciais expiradas

As credenciais do AWS Academy expiram em algumas horas. Quando isso acontecer:

1. Renove as credenciais no AWS Academy
2. Atualize o arquivo `~/.aws/credentials` ou as variáveis de ambiente
3. Execute novamente os comandos terraform

### Erro de quota/limites

Se encontrar erros de quota:

1. Verifique os limites da sua conta AWS Academy
2. Considere usar tipos de instância menores (t2.micro, t3.small)
3. Reduza o número de nós no cluster

### Erro de região

Certifique-se de estar usando `us-east-1` que é a região padrão do AWS Academy.

## Dicas Importantes

1. **Sessões**: As sessões do AWS Academy têm tempo limite. Monitore o tempo restante
2. **Créditos**: Acompanhe o uso de créditos para não exceder o limite
3. **Backup**: Faça backup do estado do Terraform (`terraform.tfstate`) se necessário
4. **Versioning**: Use Git para versionar suas mudanças

## Comandos Úteis

```powershell
# Verificar recursos criados
terraform show

# Listar recursos no estado
terraform state list

# Ver detalhes de um recurso específico
terraform state show aws_eks_cluster.cluster

# Verificar credenciais AWS
aws sts get-caller-identity

# Verificar conectividade com o cluster EKS
aws eks describe-cluster --name eks-techfood-terraform --region us-east-1
```
