---
marp: true
---

# **Aula de Terraform: Condições, Type Constraints, Laços e Blocos Dinâmicos**

Esta aula explorará aspectos avançados do Terraform, incluindo o uso de condições, restrições de tipos (type constraints), laços e blocos dinâmicos. Vamos entender como esses recursos podem ser utilizados para criar configurações mais flexíveis e poderosas, especialmente em um contexto da AWS.

---

#### **1. Condições**

**Objetivo:**
Entender como usar expressões condicionais para controlar a criação e configuração de recursos baseados em lógica específica.

**Descrição:**
Terraform suporta o uso de condições utilizando a sintaxe `condition ? true_val : false_val`, o que permite a tomada de decisões dentro da configuração.

---

**Exemplo AWS:**
```hcl
resource "aws_instance" "example" {
  count         = var.create_instance ? 1 : 0
  ami           = "ami-123456"
  instance_type = var.instance_type

  tags = {
    Name = "Instance-${var.create_instance ? "Enabled" : "Disabled"}"
  }
}
```
**Explicação:**
Neste exemplo, a instância EC2 só será criada se a variável `create_instance` for verdadeira. As tags da instância também mudarão dinamicamente baseadas na condição.

---

#### **2. Type Constraints**

**Objetivo:**
Compreender como definir e utilizar restrições de tipos para variáveis no Terraform para garantir que os valores de entrada sejam validados corretamente.

**Descrição:**
Terraform permite definir tipos para variáveis como `string`, `number`, `bool`, `list`, `map`, e `object`, ajudando a evitar erros de configuração.

---

**Exemplo AWS:**
```hcl
variable "instance_type" {
  type        = string
  description = "The type of EC2 instance to launch."
}

variable "security_groups" {
  type = list(string)
  default = ["sg-123456"]
}
```
**Explicação:**
O tipo de `instance_type` é definido como `string`, enquanto `security_groups` é uma lista de strings, definindo IDs de grupos de segurança.

---

#### **3. Laços**

**Objetivo:**
Explorar como criar múltiplos recursos ou definir múltiplas propriedades de recursos usando laços.

**Descrição:**
Terraform suporta laços usando `for_each` para criar múltiplos recursos baseados em um mapa ou lista, e `count` para iterar baseado em um número.

---

**Exemplo AWS:**
```hcl
resource "aws_security_group" "sg" {
  for_each = var.security_groups

  name        = each.key
  description = each.value
  vpc_id      = aws_vpc.main.id
}
```
**Explicação:**
Cria múltiplos grupos de segurança baseados em um mapa de valores fornecidos na variável `security_groups`, onde cada item é tratado como um recurso separado.

---

### Definindo Variáveis para Laços

#### **a. Usando `for_each` com Mapas**

Para usar `for_each` para iterar sobre um mapa de valores, você primeiro define uma variável do tipo `map`. Por exemplo, se você quiser criar múltiplos grupos de segurança com diferentes descrições:

**Definição da Variável:**
```hcl
variable "security_groups" {
  type = map(string)
  default = {
    "sg-web" = "Security group for web servers"
    "sg-db"  = "Security group for database servers"
  }
}
```

---

**Uso no Recurso:**
```hcl
resource "aws_security_group" "sg" {
  for_each    = var.security_groups
  name        = each.key
  description = each.value
  vpc_id      = aws_vpc.main.id
}
```

Neste exemplo, `each.key` representa o nome do grupo de segurança (chave do mapa) e `each.value` a descrição (valor do mapa).

---

#### **b. Usando `count` com Listas**

Quando você quer criar múltiplos recursos com base em uma lista e apenas precisa de um índice ou o valor da lista, você pode usar `count`.

**Definição da Variável:**
```hcl
variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
```

---

**Uso no Recurso:**
```hcl
resource "aws_subnet" "subnets" {
  count                   = length(var.availability_zones)
  availability_zone       = var.availability_zones[count.index]
  cidr_block              = cidrsubnet("10.0.0.0/16", 8, count.index)
  vpc_id                  = aws_vpc.main.id
}
```

Neste caso, `count.index` é usado para acessar cada elemento da lista e para fornecer um índice único para cada recurso. `cidrsubnet` é uma função do Terraform que calcula um CIDR block para cada subnet.

---

### Considerações Importantes

- **Performance:** O uso de `for_each` é geralmente preferido quando se trabalha com mapas porque mantém a relação chave-valor que pode ser útil para manutenção e clareza do código. `count` é útil para casos mais simples onde um índice sequencial ou a repetição de recursos com configuração similar é necessária.
- **Gestão de Estado:** O `for_each` gerencia melhor as mudanças no estado porque associa cada recurso a uma chave única. Com `count`, a remoção ou adição de itens na lista pode levar a recriações desnecessárias de outros recursos não diretamente modificados.

Escolher entre `for_each` e `count` depende do caso específico de uso, como você precisa manipular os dados e como deseja que o Terraform trate as mudanças de estado dos recursos.

---

#### **4. Blocos Dinâmicos**

**Objetivo:**
Aprender a usar blocos dinâmicos para configurar partes de recursos de forma condicional ou iterativa.

**Descrição:**
Blocos dinâmicos são usados para configurar repetidamente uma parte de um recurso com base em uma condição ou dados.

---

**Exemplo AWS:**
```hcl
resource "aws_instance" "example" {
  ami           = "ami-123456"
  instance_type = "t2.micro"

  dynamic "block_device_mapping" {
    for_each = var.block_devices
    content {
      device_name = block_device_mapping.value.device_name
      ebs {
        volume_size = block_device_mapping.value.volume_size
      }
    }
  }
}
```
**Explicação:**
Este exemplo cria configurações dinâmicas para mapeamento de dispositivos de blocos para uma instância EC2, baseando-se em uma variável que define os dispositivos.

---

### **Definindo Variáveis para Blocos Dinâmicos**

Para usar blocos dinâmicos eficientemente, você geralmente define uma variável que será um mapa ou uma lista, dependendo de como você quer que os blocos sejam dinâmicos. A variável servirá como base para gerar múltiplos blocos dentro de um recurso.

---

**Definição da Variável:**
```hcl
variable "block_devices" {
  description = "Map of block device configurations"
  type = map(object({
    device_name  = string
    volume_size  = number
    volume_type  = string
    delete_on_termination = bool
  }))
  default = {
    "sda1" = {
      device_name  = "/dev/sdh"
      volume_size  = 8
      volume_type  = "gp2"
      delete_on_termination = true
    },
    "sda2" = {
      device_name  = "/dev/sdi"
      volume_size  = 10
      volume_type  = "gp2"
      delete_on_termination = true
    }
  }
}
```

---

**Uso de Blocos Dinâmicos no Recurso:**
```hcl
resource "aws_instance" "example" {
  ami           = "ami-123456"
  instance_type = "t2.micro"

  dynamic "ebs_block_device" {
    for_each = var.block_devices
    content {
      device_name           = ebs_block_device.value.device_name
      volume_size           = ebs_block_device.value.volume_size
      volume_type           = ebs_block_device.value.volume_type
      delete_on_termination = ebs_block_device.value.delete_on_termination
    }
  }
}
```

---


### **Explicação dos Blocos Dinâmicos:**
- **dynamic "ebs_block_device"**: Este bloco define um bloco `ebs_block_device` dinâmico dentro da definição do recurso AWS EC2.
- **for_each**: Este argumento itera sobre cada elemento do mapa `var.block_devices`.
- **content**: Define o conteúdo do bloco dinâmico. Cada `ebs_block_device` é configurado com os atributos especificados no mapa.

---

### **Benefícios dos Blocos Dinâmicos:**
- **Flexibilidade**: Permite configurações flexíveis de recursos onde você pode especificar variações em componentes de configuração sem ter que duplicar o código para cada possível variação.
- **Redução de Código**: Reduz a quantidade de código necessário para criar múltiplos subcomponentes de um recurso, mantendo o código mais limpo e fácil de manter.
- **Escalabilidade**: Facilita a gestão e a escalabilidade de infraestruturas complexas, pois novos componentes podem ser adicionados ou removidos simplesmente ajustando os dados de entrada.

---

### **Casos de Uso para Condições, Type Constraints, Laços e Blocos Dinâmicos no Terraform**

Vamos explorar quando e por que utilizar essas funcionalidades avançadas do Terraform, fornecendo contextos específicos e benefícios de cada um desses conceitos.

---

#### **1. Condições**
**Quando usar:**
- **Ambientes Diferenciados**: Use condições quando diferentes ambientes (como desenvolvimento, teste e produção) exigirem configurações diferentes, como tipos de instância variados ou a necessidade de criar recursos adicionais em um ambiente e não em outros.
- **Feature Toggling**: Para habilitar ou desabilitar recursos com base em variáveis de configuração, facilitando testes ou lançamentos progressivos de funcionalidades.

**Por que utilizar:**
- **Flexibilidade**: Condições permitem que scripts Terraform se ajustem dinamicamente a diferentes situações sem a necessidade de alterar o código.
- **Custo-Eficiência**: Evita a criação de recursos desnecessários em certos contextos, ajudando a gerenciar custos.

---

#### **2. Type Constraints**
**Quando usar:**
- **Entradas de Módulos**: Definir tipos explícitos para as entradas de módulos Terraform para garantir que os dados passados ​​sejam do tipo esperado.
- **Validação de Configuração**: Quando você precisa garantir que as configurações passem por uma validação de tipo antes da execução, evitando erros que poderiam ser introduzidos por tipos de dados incompatíveis ou mal formatados.

**Por que utilizar:**
- **Robustez**: Reduz erros em tempo de execução verificando os dados no momento da configuração.
- **Clareza e Documentação**: Torna o código mais legível e autoexplicativo, além de facilitar o uso do módulo por outras pessoas.

---

#### **3. Laços**
**Quando usar:**
- **Criação de Múltiplos Recursos Similares**: Utilizar `for_each` ou `count` para criar vários recursos idênticos ou similares, como instâncias EC2, zonas DNS ou políticas de IAM.
- **Configurações Baseadas em Listas ou Mapas**: Quando as configurações de recursos dependem de listas ou mapas de valores, como criar interfaces de rede com várias configurações IP.

**Por que utilizar:**
- **Eficiência de Código**: Reduz a duplicação de código e melhora a manutenção ao tratar múltiplos recursos de forma programática.
- **Escalabilidade**: Facilita o escalonamento de infraestrutura, permitindo a adição de novos recursos simplesmente estendendo a lista ou o mapa de entrada.

---

#### **4. Blocos Dinâmicos**
**Quando usar:**
- **Configurações de Recursos Variáveis**: Em cenários onde partes de um recurso precisam ser configuradas dinamicamente com base em inputs externos, como ajustar regras de segurança ou anexar políticas específicas a usuários ou recursos.
- **Repetição de Sub-blocos**: Quando um recurso tem múltiplas instâncias de um sub-bloco que precisam ser geradas dinamicamente, como múltiplos discos em uma instância VM ou várias regras em um security group.

**Por que utilizar:**
- **Flexibilidade e Modularidade**: Permite a criação de configurações complexas de forma clara e reutilizável, adaptando-se dinamicamente ao contexto dado.
- **Redução de Complexidade**: Simplifica o manejo de múltiplas configurações que seriam verbosas ou complicadas de expressar estaticamente.