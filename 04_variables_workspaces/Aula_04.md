---
marp: true
---

# **Aula de Terraform: Gerenciando Variáveis e Ambientes**

#### **Objetivos da Aula**
- Compreender a importância e funcionalidade das variáveis no Terraform.
- Aprender a gerenciar diferentes ambientes utilizando workspaces no Terraform.

---

## **Parte 1: Variáveis no Terraform**

#### **Introdução às Variáveis**
- **Definição**: Variáveis no Terraform são usadas para parametrizar configurações. Elas permitem que você personalize aspectos da infraestrutura sem alterar o código principal.
- **Utilidade**: Usar variáveis torna os templates mais flexíveis e reutilizáveis, facilitando mudanças sem riscos de erros.

---

#### **Tipos de Variáveis**
- **String**: Para textos simples, como nomes e identificadores.
- **Number**: Para valores numéricos.
- **Boolean**: Para valores verdadeiro/falso.
- **List**: Uma sequência de valores homogêneos.
- **Map**: Uma coleção de valores que são acessados por uma chave.

---

### **String**

Variáveis do tipo string são utilizadas para armazenar textos simples. Elas são úteis para nomes, identificadores, URLs, entre outros.

```hcl
variable "instance_name" {
  description = "The name of the instance"
  type        = string
  default     = "my-instance"
}

resource "aws_instance" "example" {
  name = var.instance_name
  // outras configurações
}
```

---

### **Number**

Variáveis do tipo number são usadas para armazenar valores numéricos. Elas são ideais para configurar tamanhos, quantidades, portas e outros parâmetros que exigem números.

```hcl
variable "server_port" {
  description = "The port the server will use"
  type        = number
  default     = 8080
}

resource "aws_instance" "example" {
  instance_type = "t2.micro"
  user_data = <<-EOF
              #!/bin/bash
              echo "Listening on port ${var.server_port}" > /etc/config.txt
              EOF
  // outras configurações
}
```

---

### **Boolean**

Variáveis booleanas são simples, aceitando apenas dois valores: `true` ou `false`. Elas são usadas para controlar lógica condicional, ativar ou desativar recursos, entre outros.

```hcl
variable "enable_logging" {
  description = "Enable logging for the application"
  type        = bool
  default     = false
}

resource "aws_instance" "example" {
  instance_type = "t2.micro"

  provisioner "local-exec" {
    command = var.enable_logging ? "echo 'Logging is enabled'" : "echo 'Logging is disabled'"
  }
}
```

---

### **List**

Listas são coleções de valores do mesmo tipo. São usadas para especificar uma coleção de elementos, como IDs, nomes ou configurações.

```hcl
variable "availability_zones" {
  description = "A list of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

resource "aws_instance" "example" {
  count         = length(var.availability_zones)
  availability_zone = var.availability_zones[count.index]
  instance_type = "t2.micro"
}
```

---


### **Map**

Maps são coleções de pares chave-valor, onde cada valor é acessado por uma chave única. Eles são úteis para armazenar configurações relacionadas ou dados associativos.

```hcl
variable "instance_tags" {
  description = "Tags for the instance resource"
  type        = map(string)
  default     = {
    Owner       = "DevOps Team"
    Environment = "Production"
  }
}

resource "aws_instance" "example" {
  instance_type = "t2.micro"
  tags          = var.instance_tags
}
```

---

#### **Definição e Uso de Variáveis**
- **Declaração**:
  ```hcl
  variable "image_id" {
    type    = string
    default = "ami-abc123"
  }
  ```
- **Utilização**:
  ```hcl
  resource "aws_instance" "example" {
    ami           = var.image_id
    instance_type = "t2.micro"
  }
  ```

---

#### **Variáveis de Entrada e Saída**
- **Variáveis de Entrada**: São configuradas externamente pelo usuário do módulo.
- **Variáveis de Saída**: Permitem que um módulo exponha alguns de seus valores para outros módulos.
  ```hcl
  output "instance_ip_addr" {
    value = aws_instance.example.public_ip
  }
  ```

---

### **Parte 2: Ambientes no Terraform**

#### **Introdução aos Ambientes no Terraform**
- **Definição**: Ambientes são usados para gerenciar estados diferentes para conjuntos de configurações, geralmente correspondendo a estágios de desenvolvimento, staging e produção.

#### **Uso de Workspaces**
- **Criação de Workspaces**: Separa o estado do Terraform em múltiplos workspaces para evitar conflitos e facilitar a gestão.
  ```bash
  terraform workspace new dev
  terraform workspace new prod
  ```

---

#### **Estratégias de Organização**
- **Organização de Arquivos**: Mantenha arquivos específicos do ambiente separados ou use diretórios separados para cada ambiente.

### **Workspace**

O comando `terraform workspace` no Terraform é utilizado para gerenciar diferentes "workspaces" (espaços de trabalho), que são ambientes isolados com seus próprios estados, permitindo que os usuários mantenham múltiplas instâncias distintas da mesma infraestrutura de forma paralela. Cada workspace possui seu próprio arquivo de estado, permitindo que você altere configurações sem afetar outros ambientes, como desenvolvimento, teste e produção.

---

Aqui estão alguns dos subcomandos mais comuns e suas funções:

### **Listar Workspaces**
```bash
terraform workspace list
```
- Lista todos os workspaces existentes.

---

### **Criar um Novo Workspace**
```bash
terraform workspace new [workspace-name]
```
- Cria um novo workspace com o nome especificado. Isso permite que você configure e aplique recursos sem impactar o estado de outros workspaces.

---

### **Selecionar um Workspace**
```bash
terraform workspace select [workspace-name]
```
- Muda para um workspace existente. Todas as operações do Terraform aplicadas após esse comando afetarão apenas o estado dentro desse workspace.

---

### **Excluir um Workspace**
```bash
terraform workspace delete [workspace-name]
```
- Exclui um workspace específico. Isso é útil para limpar ambientes de teste ou desenvolvimento que não são mais necessários.

---

### **Mostrar o Workspace Atual**
```bash
terraform workspace show
```
- Exibe o nome do workspace atualmente selecionado.

---

### Utilidade dos Workspaces
Os workspaces são particularmente úteis em cenários onde múltiplos ambientes precisam ser gerenciados de forma isolada, mas com configurações semelhantes. Por exemplo, você pode querer manter ambientes de desenvolvimento, teste e produção para uma aplicação, cada um com sua própria configuração de recursos, mas todos baseados no mesmo conjunto de arquivos de configuração do Terraform. Isso simplifica o gerenciamento de configurações complexas e reduz o risco de alterações acidentais em ambientes sensíveis, como a produção.

Ao usar workspaces, você pode especificar variáveis diferentes para cada ambiente usando arquivos `-var` ou `-var-file` durante a execução dos comandos `terraform plan` e `terraform apply`, ajustando assim as configurações conforme necessário para cada ambiente sem a necessidade de duplicar a base de código.

---

### **Exercício Prático**

#### **Configuração de uma Instância AWS usando Variáveis e Workspaces**

**Setup Inicial**:
- **main.tf**:
  ```hcl
  provider "aws" {
    region = var.region
  }

  resource "aws_instance" "example" {
    ami           = var.image_id
    instance_type = var.instance_type
    tags = {
      Name = "Example-${terraform.workspace}"
    }
  }
  ```

---

- **variables.tf**:
  ```hcl
  variable "region" {
    default = "us-east-1"
  }

  variable "image_id" {
    type    = string
  }

  variable "instance_type" {
    type    = string
  }
  ```

---

- **dev.tfvars**:
  ```hcl
  image_id      = "ami-abc123"
  instance_type = "t2.micro"
  ```

- **prod.tfvars**:
  ```hcl
  image_id      = "ami-def456"
  instance_type = "t2.micro"
  ```

**Execução**:
- Ativar o workspace e aplicar a configuração:
  ```bash
  terraform workspace select dev
  terraform apply -var-file="dev.tfvars"

  terraform workspace select prod
  terraform apply -var-file="prod.tfvars"
  ```

---

### **Extra**

Para descobrir as possíveis variáveis de saída em um projeto Terraform, você tem algumas opções, dependendo de como o projeto é estruturado e se você está trabalhando com módulos ou apenas com sua própria configuração. Aqui estão algumas maneiras de identificar e obter informações sobre as variáveis de saída disponíveis.

---

### **Examinar o Código Terraform**
A primeira e mais direta abordagem é olhar os arquivos Terraform (`*.tf`) em busca de blocos definidos com a palavra-chave `output`. Cada bloco de saída define uma variável de saída que o Terraform calcula e pode tornar acessível. Por exemplo:

```hcl
output "instance_ip_addr" {
  value = aws_instance.example.public_ip
  description = "The public IP address of the EC2 instance"
}
```

---

### **Usar o Comando `terraform output`**
Se você já rodou `terraform apply` e o Terraform gerou um estado, você pode listar todas as variáveis de saída definidas usando o comando:

```bash
terraform output
```

Esse comando mostrará todas as saídas definidas no projeto atual junto com seus valores atuais. Se você quiser o valor de uma saída específica, você pode especificar seu nome:

```bash
terraform output instance_ip_addr
```

---

### **Documentação do Módulo**
Se você estiver utilizando módulos de terceiros, como aqueles encontrados no Terraform Registry, a documentação do módulo geralmente incluirá uma seção de saídas. Esta seção lista todas as variáveis de saída que o módulo fornece, junto com descrições do que elas representam. Isso é útil para entender quais dados você pode esperar como saída ao usar o módulo.

---

### **Examinando Arquivos de Estado**
Em circunstâncias avançadas e para depuração, você pode examinar diretamente o arquivo de estado do Terraform (geralmente `terraform.tfstate`). Este arquivo contém todos os valores de saída atuais, além de muitas outras informações sobre o estado atual da infraestrutura. **Aviso:** Interagir diretamente com o arquivo de estado pode ser arriscado; não modifique o arquivo sem entender completamente as implicações.

---

### **Comandos do Terraform Console**
O Terraform também possui um console interativo que pode ser usado para consultar dados do estado atual. Você pode acessá-lo executando:

```bash
terraform console
```

Dentro do console, você pode digitar o nome de uma variável de saída para ver seu valor atual, como:

```plaintext
> aws_instance.example.public_ip
```

---

### Conclusão
A maneira mais segura e recomendada de verificar as variáveis de saída é através do código Terraform e do comando `terraform output`. Estas abordagens garantem que você está trabalhando com informações atualizadas e configuradas corretamente. Utilize a documentação do módulo e o console para consultas adicionais ou quando você precisar de mais contexto sobre como as saídas são geradas.