---
marp: true
---

# **Aula: Infraestrutura como Código com Terraform**

## **Objetivo da Aula**
Introduzir os conceitos fundamentais da Infraestrutura como Código (IaC) utilizando o Terraform, incluindo as premissas de configuração com HashiCorp Configuration Language (HCL), o uso de provisioners e a gestão de states.

---

## **1. Premissas de Configuração com HCL**

- **Definição e Importância do HCL**
  - Explicação sobre a HashiCorp Configuration Language (HCL), uma linguagem declarativa para descrever a infraestrutura como código.
  - Importância do HCL na criação de templates legíveis e facilmente gerenciáveis.

---

- **Exemplo Prático: Configurando um Bucket S3**
  - **Código**:
    ```hcl
    provider "aws" {
      region = "us-east-1"
    }

    resource "aws_s3_bucket" "meu_bucket" {
      bucket = "meu-bucket-terraform-unico"
      acl    = "private"

      tags = {
        Nome = "Meu Bucket Terraform"
      }
    }
    ```
  - **Explicação**: Neste exemplo, um bucket S3 é criado na AWS. O exemplo mostra como definir um provider, recursos e atributos como região, nome do bucket e políticas de acesso.

---

## **2. Como Utilizar os Provisioners**

- **O que são Provisioners?**
  - Explicação de que os provisioners no Terraform são usados para executar scripts em máquinas locais ou remotas após a criação de um recurso.

---

- **Exemplo Prático: Instalando Software em uma Instância EC2**
  - **Código**:
    ```hcl
    resource "aws_instance" "example" {
      ami           = "ami-0c55b159cbfafe1f0"
      instance_type = "t2.micro"

      provisioner "remote-exec" {
        inline = [
          "sudo apt-get update",
          "sudo apt-get install -y nginx"
        ]
      }
    }
    ```
  - **Explicação**: Este exemplo demonstra a criação de uma instância EC2 e a instalação do Nginx usando um provisioner `remote-exec`. O provisioner executa comandos na instância assim que ela é criada.

---

## **3. Entender sobre States**

- **O que é State no Terraform?**
  - Discussão sobre o Terraform state, um arquivo que contém todos os metadados necessários para o Terraform entender as mudanças em um ambiente.

- **Exemplo Prático: Visualizando e Modificando o State**
  - **Código**:
    ```bash
    terraform state list
    terraform state show aws_s3_bucket.meu_bucket
    ```
  - **Explicação**: Esses comandos são usados para visualizar todos os recursos gerenciados pelo Terraform e detalhes específicos sobre um recurso, neste caso, um bucket S3.

---

## **Conclusão**

- **Resumo das Aprendizagens**
  - Recapitulação dos conceitos de configuração com HCL, o uso de provisioners para gerenciar configurações de software, e a importância do state para o gerenciamento eficaz da infraestrutura.

- **Recursos Adicionais**
  - Encorajamento para explorar a documentação oficial do Terraform para aprofundamento e práticas avançadas.
