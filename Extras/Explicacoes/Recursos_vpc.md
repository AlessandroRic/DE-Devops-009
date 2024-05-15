---
marp: true
---

# **VPC (Virtual Private Cloud)**

Esta provisão de recursos é essencial para configurar uma rede isolada dentro da AWS ou outra cloud, onde seus recursos de computação podem operar de forma segura.

---

### 1. **AWS VPC (Virtual Private Cloud)**

```hcl
resource "aws_vpc" "ecs_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.project_name}-vpc"
  }
}
```

---

**Explicação:**
- **CIDR Block**: Define o bloco de IPs para a VPC. `10.0.0.0/16` significa que você pode ter 65.536 endereços IP privados dentro desta VPC, variando de `10.0.0.0` a `10.0.255.255`.
- **enable_dns_support e enable_dns_hostnames**: Estas opções ativam o suporte DNS dentro da VPC, permitindo que você use nomes de domínio amigáveis em vez de apenas endereços IP.
- **tags**: Usado para nomear recursos de forma que eles possam ser facilmente identificados no console AWS.

---

### 2. **Subnets**

```hcl
resource "aws_subnet" "ecs_subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.ecs_vpc.id
  cidr_block              = count.index == 0 ? "10.0.1.0/24" : "10.0.2.0/24"
  availability_zone       = count.index == 0 ? "us-east-1a" : "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project_name}-subnet-${count.index}"
  }
}
```

---

**Explicação:**
- **count**: Cria duas subnets, aumentando a disponibilidade e a tolerância a falhas do sistema.
- **cidr_block**: Cada subnet tem um bloco de IP próprio, limitado a 256 IPs possíveis por subnet.
- **availability_zone**: Subnets em diferentes zonas de disponibilidade para garantir que a falha de uma zona não afete a outra.
- **map_public_ip_on_launch**: Automaticamente atribui IPs públicos a instâncias lançadas nestas subnets, tornando-as acessíveis da internet.

---

### 3. **Internet Gateway**

```hcl
resource "aws_internet_gateway" "ecs_igw" {
  vpc_id = aws_vpc.ecs_vpc.id
  tags = {
    Name = "${var.project_name}-igw"
  }
}
```

**Explicação:**
- **Internet Gateway**: Atua como um portal entre a sua VPC e a internet, permitindo comunicação entre os recursos da AWS e o mundo externo.

---

### 4. **Route Table**

```hcl
resource "aws_route_table" "ecs_route_table" {
  vpc_id = aws_vpc.ecs_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecs_igw.id
  }
  tags = {
    Name = "${var.project_name}-route-table"
  }
}
```

**Explicação:**
- **Route Table**: Define regras que determinam onde o tráfego de rede deve ser direcionado. Neste caso, todo o tráfego destinado a qualquer endereço é enviado para o Internet Gateway.

---

### 5. **Route Table Association**

```hcl
resource "aws_route_table_association" "ecs_route_table_assoc" {
  count          = length(aws_subnet.ecs_subnet)
  subnet_id      = aws_subnet.ecs_subnet[count.index].id
  route_table_id = aws_route_table.ecs_route_table.id
}
```

**Explicação:**
- **Route Table Association**: Associa a tabela de rotas com as subnets criadas, garantindo que o tráfego saindo dessas subnets passe pelo Internet Gateway.

---

### Resumo

Ao criar esta configuração de VPC com o Terraform, você está construindo a base da rede que suportará todos os outros serviços AWS que você planeja usar. Isso inclui segmentar a rede para controle de tráfego, proteger seus recursos com subnets privadas e públicas, e conectar sua rede privada à internet de maneira controlada. Cada componente é crucial para a segurança, escalabilidade e eficiência da sua infraestrutura na nuvem.