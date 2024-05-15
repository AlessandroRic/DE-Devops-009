---
marp: true
---

# **Aula de Terraform: Utilizando Módulos e Backend**

---

#### **Objetivos da Aula**
- Compreender e aplicar módulos no Terraform para promover reutilização e organização de código.
- Explorar o uso de backends no Terraform para gerenciamento eficiente do estado e colaboração em equipe.

---

# **Parte 1: Módulos no Terraform**

---

## **Introdução aos Módulos**
- **O que são Módulos?**
  - Módulos no Terraform são contêineres para grupos de recursos relacionados que são usados juntos. Eles ajudam a organizar a infraestrutura como código de maneira modular.

- **Por que usar Módulos?**
  - **Reutilização**: Módulos permitem que você reuse código para criar infraestruturas semelhantes sem duplicação, reduzindo erros e economizando tempo.
  - **Organização**: Facilitam a manutenção do código ao dividir componentes complexos em blocos gerenciáveis.
  - **Encapsulamento**: Os módulos podem encapsular detalhes, expondo apenas as configurações necessárias através de variáveis.

---

## **Criando e Usando Módulos**
- **Exemplos Práticos de Módulos**: 
  - **Módulo para Instância EC2**:
    ```hcl
    # /modules/ec2/main.tf
    resource "aws_instance" "example" {
      ami           = var.ami_id
      instance_type = var.instance_type
      tags          = var.tags
    }

    # /modules/ec2/variables.tf
    variable "ami_id" {}
    variable "instance_type" {}
    variable "tags" {}

    # /modules/ec2/outputs.tf
    output "instance_id" {
      value = aws_instance.example.id
    }
    ```
---

  - **Módulo para Bucket S3**:
    ```hcl
    # /modules/s3/main.tf
    resource "aws_s3_bucket" "bucket" {
      bucket = var.bucket_name
      acl    = "private"
    }

    # /modules/s3/variables.tf
    variable "bucket_name" {}

    # /modules/s3/outputs.tf
    output "bucket_arn" {
      value = aws_s3_bucket.bucket.arn
    }
    ```
---

  - **Incorporando os Módulos no Projeto Principal**:
    ```hcl
    module "web_server" {
      source        = "./modules/ec2"
      ami_id        = "ami-123456"
      instance_type = "t2.micro"
      tags          = { Name = "WebServer" }
    }

    module "storage" {
      source      = "./modules/s3"
      bucket_name = "my-unique-bucket-name-12345"
    }
    ```

---

# **Parte 2: Backend no Terraform**

---

## **Introdução ao Gerenciamento de Estado**
- **O que é Gerenciamento de Estado?**
  - O gerenciamento de estado no Terraform envolve manter um registro dos recursos provisionados em um arquivo de estado. Este arquivo é usado pelo Terraform para mapear recursos reais aos recursos configurados no código, permitindo que o Terraform saiba o que precisa ser criado, atualizado ou deletado.
  
- **Por que um Backend é Crucial?**
  - Um backend permite armazenar esse arquivo de estado de maneira centralizada e segura, e muitos backends suportam operações de bloqueio para prevenir condições de corrida quando várias pessoas estão trabalhando no mesmo conjunto de infraestruturas.

---

## **Configurando e Usando um Backend**
- **Exemplo de Configuração de Backend com AWS S3**:
  ```hcl
  # backend.tf
  terraform {
    backend "s3" {
      bucket         = "my-terraform-state-bucket"
      key            = "state/terraform.tfstate"
      region         = "us-east-1"
      encrypt        = true
      dynamodb_table = "my-lock-table"
    }
  }
  ```

---

## **Exercício Prático**

#### **Objetivo:**
Implementar uma infraestrutura usando módulos personalizados para um bucket S3 e uma instância EC2 e configurar um backend remoto para gerenciamento do estado.

#### **Tarefas:**
1. **Criar um Módulo para um Bucket S3 e uma Instância EC2**.
2. **Utilizar os Módulos para provisionar o bucket e a instância EC2 através de diferentes workspaces**.
3. **Apresentar o que foi criado, e como foi criado**

---

# **Referência de estudos Extra Classe**

[Documentação Azure Terraform](https://learn.microsoft.com/pt-br/azure/developer/terraform/)
[Onde buscar imagens Ubuntu](https://cloud-images.ubuntu.com/)
[O Mago do terraform](https://terragrunt.gruntwork.io/)
[Tutoriais](https://developer.hashicorp.com/terraform/tutorials/azure-get-started)

