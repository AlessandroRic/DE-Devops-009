---
marp: true
---

# **Aula: Infraestrutura como Código com Terraform**

---

## **Introdução ao Conceito de Infraestrutura como Código (IaC)**
**Definição de IaC**
Infraestrutura como Código é uma prática de engenharia de software que usa códigos para gerenciar configurações e automação de infraestrutura de TI. Ao invés de configurar manualmente hardware, sistemas operacionais, e aplicações, o IaC usa scripts para criar, modificar e destruir recursos, garantindo que a infraestrutura seja ajustável e replicável.

---

**Benefícios do IaC**
- **Automatização**: Permite a criação rápida de ambientes de forma consistente, evitando o esforço manual repetitivo.
- **Consistência**: Garante que todos os ambientes sejam configurados de maneira uniforme, evitando discrepâncias conhecidas como "drifts".
- **Redução de erros humanos**: Minimiza as falhas operacionais ao substituir tarefas manuais por scripts.
- **Versionamento**: Permite que a infraestrutura seja versionada e rastreada como qualquer código de software.

---

## **O que é o Terraform**
**Visão Geral**
Terraform é uma ferramenta open-source desenvolvida pela HashiCorp que permite a construção, mudança e versionamento de infraestrutura de forma segura e eficiente. Ela suporta diversos provedores de serviços de nuvem como AWS, Microsoft Azure, Google Cloud Platform, entre outros.

**Características Principais**
- **Declarativo**: Você define o que deve ser criado, não como deve ser criado.
- **Idempotente**: As operações garantem que, não importa quantas vezes sejam executadas, o resultado final será o mesmo.
- **Independente de provedor**: Pode gerenciar recursos em diferentes plataformas com o mesmo conjunto de ferramentas.

---

## **Estrutura do Código Terraform**
**Arquivos de Configuração**
Os arquivos `.tf` contêm a configuração escrita em HCL (HashiCorp Configuration Language), que é uma linguagem declarativa específica para o Terraform. O estado da infraestrutura gerenciada é mantido em arquivos `.tfstate`.

---

**Providers**
São plugins que permitem ao Terraform interagir com APIs de provedores de nuvem. Cada provedor oferece recursos específicos que podem ser gerenciados através do Terraform.

**Resources e Modules**
- **Resources**: São componentes individuais da infraestrutura, como uma instância EC2 ou um bucket S3.
- **Modules**: São contêineres para múltiplos recursos que são usados juntos. Módulos podem ser reutilizados em diferentes projetos, promovendo a reutilização do código.

---

## **Primeiros Passos com o Terraform**
**Instalação e Configuração**
Você pode instalar o Terraform baixando o binário apropriado do [site oficial](https://www.terraform.io/downloads.html) e adicionando-o ao PATH do seu sistema.

---

**Criação de um Projeto Básico**
Para começar com o Terraform, crie um diretório para o seu projeto e dentro dele um arquivo `main.tf`. Este arquivo conterá a definição dos recursos que deseja criar.

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

**Gerenciamento de Estado**
O Terraform mantém um registro do estado atual dos recursos no arquivo `terraform.tfstate`. Este arquivo deve ser tratado com cuidado, pois contém informações sensíveis e é crucial para as operações do Terraform.

---

## **Melhores Práticas com Terraform**
**Organização do Código**
Estruture seus diretórios de forma lógica, separando os ambientes de produção, desenvolvimento e testes, e agrupando recursos relacionados em módulos

**Segurança e Sensibilidade dos Dados**
Utilize variáveis para passar dados sensíveis ao Terraform e nunca os inclua diretamente nos arquivos de configuração. Considere o uso do Terraform Cloud ou Enterprise para gerenciamento seguro do estado.

---

# **Pilares do IaC**

---

### **1. ADHoc Scripts: Shell Scripts de Nível Básico**
- **Definição**: Scripts de shell e outros scripts de linha de comando são frequentemente os primeiros passos na automação da infraestrutura. Eles permitem a execução de tarefas repetitivas e podem ser usados para automação de processos simples.
- **Exemplos**:
  - **Bash** (Linux, macOS): Utilizado para automação de tarefas do sistema e gerenciamento de processos.
  - **PowerShell** (Windows, Linux, macOS): Empregado extensivamente para automação e gerenciamento de configurações em ambientes Windows e outros sistemas.
  - **Python**: Usado para scripts mais complexos devido à sua flexibilidade e extensa biblioteca de suporte.
- **Utilização**: Ideal para gerenciamento de pacotes, configuração inicial de servidores, automação de backups, entre outros.

---

## **2. Config Tools**
- **Definição**: Ferramentas como Ansible gerenciam a configuração de sistemas de software em múltiplas máquinas de forma idempotente, garantindo que as configurações sejam repetíveis e não alterem o estado atual se já atenderem às especificações.
- **Exemplos**:
  - **Chef**: Baseado em Ruby, utiliza "receitas" para definir o estado desejado de uma máquina.
  - **Puppet**: Gerencia configurações através de um modelo declarativo, comum em ambientes de grande escala.
  - **SaltStack**: Proporciona uma abordagem rápida e escalável para automação de data centers e nuvens, usando Salt.
- **Utilização**: Útil para configuração de servidores, instalação e atualizações de software, e manutenção de segurança.

---

## **3. Template: Imagem como Código**
- **Definição**: Ferramentas como Packer permitem criar imagens de máquina idênticas para múltiplas plataformas a partir de uma única configuração. Este processo é conhecido como "Imagem como Código".
- **Exemplos**:
  - **Docker**: Cria e gerencia contêineres, facilitando o desenvolvimento e implantação consistentes através de imagens de contêiner.
  - **Vagrant**: Foca na criação e configuração de ambientes de máquinas virtuais portáteis e reprodutíveis para desenvolvimento.
- **Utilização**: Ideal para a criação de imagens pré-configuradas que podem ser rapidamente implantadas, garantindo consistência entre ambientes de desenvolvimento, teste e produção.

---

## **4. Orquestração como Código**
- **Definição**: Kubernetes é um sistema de orquestração de contêineres que automatiza a implantação, escala e operações de aplicações contêinerizadas. As configurações de contêineres e clusters são definidas em arquivos YAML ou JSON.
- **Exemplos**:
  - **Docker Swarm**: Solução de orquestração nativa do Docker, focada na gestão de clusters de contêineres.
  - **Apache Mesos**: Gerencia clusters capazes de executar e escalar aplicações em plataformas distribuídas.
  - **OpenShift**: Plataforma baseada em Kubernetes que oferece automação adicional e funcionalidades empresariais.
- **Utilização**: Gerenciamento de contêineres em ambientes de produção, automação de implantações e escalonamento.

---

## **5. Provisionamento como Infra**
- **Definição**: Terraform é uma ferramenta que permite criar, alterar e versionar infraestrutura de forma segura e eficiente. Usa arquivos de configuração para descrever os componentes necessários para operar uma aplicação ou serviço.
- **Exemplos**:
  - **AWS CloudFormation**: Define e provisiona infraestrutura da AWS através de arquivos de configuração.
  - **Azure Resource Manager (ARM)**: Gerencia e provisiona recursos no Azure usando templates.
  - **Google Cloud Deployment Manager**: Ferramenta para criar, configurar e gerenciar recursos do Google Cloud usando templates declarativos.
- **Utilização**: Criação e gestão de infraestrutura completa em vários provedores de nuvem, permitindo a construção de ambientes complexos de forma reprodutível.
