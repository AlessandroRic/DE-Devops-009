---
marp: true
---

# **Aula de Terraform: Dependências entre Recursos e Comandos Especiais**

---

#### **Objetivos da Aula**
- Compreender como o Terraform gerencia as dependências entre recursos.
- Aprender a usar comandos especiais do Terraform como taint, graph, fmt e validate.
- Aplicar esses conceitos em projetos práticos na AWS e Azure.

---

# **Parte 1: Dependências entre Recursos**

---

1. **Introdução às Dependências Implícitas e Explícitas**
   - **Definição**: Diferença entre dependências criadas automaticamente pelo Terraform e aquelas definidas explicitamente pelo usuário.
   - **Exemplo AWS**:
     ```hcl
     resource "aws_instance" "app" {
       ami           = "ami-123456"
       instance_type = "t2.micro"
       subnet_id     = aws_subnet.example.id
     }

     resource "aws_subnet" "example" {
       vpc_id     = aws_vpc.example.id
       cidr_block = "10.0.1.0/24"
     }
     ```
     Neste exemplo, a instância EC2 depende implicitamente da subnet devido ao uso do `subnet_id`.

---

   - **Exemplo Azure**:
     ```hcl
     resource "azurerm_virtual_machine" "app" {
       name                  = "examplevm"
       location              = azurerm_resource_group.example.location
       resource_group_name   = azurerm_resource_group.example.name
       network_interface_ids = [azurerm_network_interface.example.id]
       vm_size               = "Standard_DS1_v2"
     }

     resource "azurerm_network_interface" "example" {
       name                = "example-nic"
       location            = azurerm_resource_group.example.location
       resource_group_name = azurerm_resource_group.example.name
       ip_configuration {
         name                          = "internal"
         subnet_id                     = azurerm_subnet.example.id
         private_ip_address_allocation = "Dynamic"
       }
     }
     ```
     Aqui, a máquina virtual depende explicitamente da interface de rede.

---

2. **Uso do Atributo `depends_on`**
   - Explicação sobre como forçar uma dependência explícita que não é detectada automaticamente pelo Terraform.
   - **Exemplo**:
     ```hcl
     resource "aws_s3_bucket" "example" {
       bucket = "my-tf-test-bucket"
       acl    = "private"
     }

     resource "aws_instance" "app" {
       ami           = "ami-123456"
       instance_type = "t2.micro"
       depends_on    = [aws_s3_bucket.example]
     }
     ```

---

# **Parte 2: Comandos Especiais do Terraform**

---

1. **Comando `taint`**
   - **Uso**: O comando taint marca um recurso do Terraform para ser destruído e recriado na próxima execução do apply. Isso é útil quando você quer forçar a atualização de um recurso sem mudar qualquer código.
   - **Exemplo**:
     ```bash
     terraform taint aws_instance.app
     ```
     Este comando marca uma instância EC2 específica para ser recriada na próxima vez que terraform apply for executado.

---

2. **Comando `graph`**
   - **Uso**: O comando graph é usado para gerar um gráfico visual das dependências entre todos os recursos gerenciados pelo Terraform em uma configuração. É uma ferramenta poderosa para entender como os recursos estão interligados.
   - **Exemplo**:
     ```bash
     terraform graph | dot -Tsvg > graph.svg
     terraform graph | dot -Tpng > architecture.png
     ```
     Este comando produz um arquivo PNG do gráfico de dependências. Requer que você tenha o Graphviz instalado, que é o software que processa a descrição do gráfico gerado pelo Terraform.

---

3. **Comando `fmt`**
   - **Uso**: O comando fmt é usado para reformatar os arquivos Terraform para um estilo canônico e consistente. Isso ajuda a manter o código limpo e padronizado.
   - **Exemplo**:
     ```bash
     terraform fmt
     ```
     Este comando reformatará todos os arquivos de configuração Terraform no diretório atual, ajustando a indentação, alinhamento e outros elementos de estilo.
---

4. **Comando `validate`**
   - **Uso**: O comando validate verifica se os arquivos de configuração são sintaticamente válidos e internamente consistentes, sem consultar a infraestrutura real (ou seja, não faz nenhuma chamada de API).
   - **Exemplo**:
     ```bash
     terraform validate
     ```
    Este comando irá verificar se há erros na configuração Terraform do diretório atual, ajudando a identificar problemas antes de aplicar as mudanças.

---

# **Exercício Prático**

#### **Objetivo:**
Implementar uma infraestrutura que envolva múltiplos recursos na AWS, aplicando o conhecimento sobre dependências e utilizando comandos especiais para garantir a qualidade e a eficácia da configuração.

#### **Tarefas:**
1. **Criar uma infraestrutura básica** na AWS e Azure usando recursos como instâncias, redes e armazenamentos.
2. **Utilizar o comando `graph`** para visualizar as dependências.
3. **Aplicar `fmt` e `validate`** para assegurar que a configuração está correta.
4. **Usar `taint`** em um recurso e observar o efeito durante o `apply`.

---

Aqui estão os passos para utilizar o `terraform graph` no Windows:

# Instalar o Graphviz

1. **Instalar o Graphviz**: O Graphviz é uma ferramenta de software de código aberto para desenhar gráficos descritos em DOT. Ele pode ser instalado no Windows.
   - Você pode baixar o instalador do Graphviz da [página de downloads do Graphviz](https://graphviz.org/download/).
   - Siga as instruções de instalação no site para instalar o Graphviz em seu sistema Windows.

---

# Gerar o Gráfico com Terraform

2. **Gerar o Gráfico**:
   - Abra o Prompt de Comando ou o PowerShell no diretório do seu projeto Terraform.
   - Execute o comando `terraform graph` para gerar o gráfico em formato DOT:
     ```bash
     terraform graph > graph.dot
     ```
   - Isso salva a saída do gráfico em um arquivo chamado `graph.dot`.

---

# Converter o Gráfico para Formato de Imagem

3. **Converter o Gráfico para uma Imagem**:
   - Ainda no Prompt de Comando ou PowerShell, utilize o Graphviz para converter o arquivo DOT em uma imagem. Por exemplo, para criar uma imagem PNG:
     ```bash
     dot -Tpng graph.dot -o graph.png
     ```
   - Este comando lê o arquivo `graph.dot`, processa o gráfico e salva a saída como `graph.png`.

---

# Visualizar o Gráfico

4. **Visualizar a Imagem**:
   - Você pode abrir o arquivo `graph.png` com qualquer visualizador de imagens padrão no Windows, como o Visualizador de Fotos do Windows ou qualquer outro software de visualização de imagens que você tenha instalado.

---

# Solução de Problemas

- **Verificar o PATH**: Após instalar o Graphviz, certifique-se de que o diretório bin do Graphviz está no PATH do seu sistema. Isso permite que você execute o comando `dot` de qualquer lugar no Prompt de Comando ou PowerShell.
- **Erro no Graphviz**: Se você encontrar erros ao executar o comando `dot`, verifique se a instalação foi concluída corretamente e se o PATH está configurado apropriadamente.