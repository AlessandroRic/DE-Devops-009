---
marp: true
---

# **Aula: Core Workflow do Terraform, Dependências e Providers**

---

## **Objetivo da Aula**
- Fornecer um entendimento prático e teórico do fluxo de trabalho principal do Terraform, como gerenciar dependências entre recursos e como utilizar providers para interagir com APIs de serviços de infraestrutura.
- Exercício de fixação relacionado aos pontos apresentados na primeira aula.

---

## **1. Introdução ao Core Workflow do Terraform**

- **Definição e Importância**
  - Explicação do que é o core workflow do Terraform, que inclui as etapas de escrever, planejar, criar e modificar infraestrutura como código.
  - Importância do core workflow para garantir que a infraestrutura seja provisionada de forma consistente e segura.

---

- **Etapas do Core Workflow**
  - **Write (Escrever)**: Desenvolvimento dos arquivos de configuração usando a HashiCorp Configuration Language (HCL).
  - **Plan (Planejar)**: Execução do comando `terraform plan` para verificar quais alterações serão aplicadas na infraestrutura.
  - **Apply (Aplicar)**: Uso do comando `terraform apply` para aplicar as mudanças desejadas no ambiente de infraestrutura.
  
---

- **Exemplo Prático**
  - Criação de um arquivo de configuração simples para provisionar uma instância EC2 na AWS:
    ```hcl
    provider "aws" {
      region = "us-east-1"
    }

    resource "aws_instance" "example" {
      ami           = "ami-0c55b159cbfafe1f0"
      instance_type = "t2.micro"
    }
    ```

---

## **2. Dependências no Terraform**

- **Como o Terraform Gerencia Dependências**
  - Discussão sobre como o Terraform automaticamente determina dependências entre recursos baseado nas configurações fornecidas.
  - Exemplo de dependências implícitas (e.g., uma instância EC2 que precisa de um Security Group).

---

- **Definindo Dependências Explícitas**
  - Uso de `depends_on` para definir dependências manuais quando o Terraform não consegue resolver automaticamente.
  - Exemplo:
    ```hcl
    resource "aws_security_group" "example" {
      name = "example-security-group"
    }

    resource "aws_instance" "example" {
      ami           = "ami-0c55b159cbfafe1f0"
      instance_type = "t2.micro"
      security_groups = [aws_security_group.example.name]
      depends_on    = [aws_security_group.example]
    }
    ```

---

## **3. Providers no Terraform**

- **O que são Providers?**
  - Explicação de que providers no Terraform são plugins que permitem ao Terraform gerenciar recursos de diferentes serviços e plataformas, como AWS, Google Cloud, Azure, etc.

---

- **Configurando e Usando Providers**
  - Detalhes sobre como configurar um provider, especificando versão, credenciais e região.
  - Exemplo com o provider da AWS:
    ```hcl
    provider "aws" {
      region     = "us-east-1"
      access_key = "your_access_key"
      secret_key = "your_secret_key"
    }
    ```

---

- **Melhores Práticas com Providers**
  - Dicas para gerenciar versões dos providers, usando o bloco `required_providers` para garantir compatibilidade e estabilidade.
  - Exemplo:
    ```hcl
    terraform {
      required_providers {
        aws = {
          source  = "hashicorp/aws"
          version = "~> 3.0"
        }
      }
    }
    ```

---

## Exercício de Fixação
- Criar um sistema semelhante ao da primeira aula porém agora criando uma instancia de máquina virtual no ambiente do LocalStack.
  - O foco do exercício é ter o contato com o terraform e iniciar a utilização do mesmo de forma prática.

Dicas:
- O nome do recurso necessário é EC2
- Utilizar a documentação apresentada pela Hashcorp

---
## **Complementar**

- **Resumo das Aprendizagens**
  - Revisão dos pontos principais sobre o core workflow do Terraform, gestão de dependências e a importância dos providers.
  
- **Recursos Adicionais**
  - Encorajamento para explorar a [documentação oficial do Terraform](https://www.terraform.io/docs) para aprofundamento e resolução de dúvidas específicas.

- **Documentação provider Azure**
  - Documentação sobre como estabelecer o provider AzureRM - [Doc AzureRM](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)