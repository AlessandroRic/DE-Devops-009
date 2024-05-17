# Define uma Virtual Private Cloud (VPC) na AWS com um bloco CIDR específico. 
# Uma VPC permite que você crie uma rede isolada dentro da AWS.
resource "aws_vpc" "example_vpc" {
  cidr_block         = "10.0.0.0/16" # Especifica o bloco CIDR para toda a VPC, permitindo ~65k endereços IP privados.
  enable_dns_support = true          # Habilita o suporte a DNS dentro da VPC.
  tags = {                           # Tags são metadados usados para identificar e organizar recursos na AWS.
    Name = "example-vpc"
  }
}

# Define uma subnet dentro da VPC criada. Subnets permitem segmentar a VPC em redes menores.
resource "aws_subnet" "example_subnet" {
  vpc_id            = aws_vpc.example_vpc.id # Associa a subnet à VPC criada anteriormente.
  cidr_block        = "10.0.1.0/24"          # Define um bloco CIDR para a subnet, permitindo 256 endereços IP.
  availability_zone = "us-east-1a"           # Especifica em qual zona de disponibilidade a subnet está localizada.
  tags = {
    Name = "example-subnet"
  }
}

# Define um grupo de segurança na VPC para controlar o tráfego de entrada e saída.
resource "aws_security_group" "example_sg" {
  name        = "example-sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.example_vpc.id # Associa o Security Group à VPC criada.

  # Regra de entrada: permite tráfego HTTP (porta 80) de qualquer IP.
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Regra de saída: permite todo o tráfego de saída.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Cria uma instância EC2 que usa a subnet e o grupo de segurança definidos.
resource "aws_instance" "example_instance" {
  ami                    = var.ami_id                         # ID da AMI usada para lançar a instância.
  instance_type          = "t2.micro"                         # Tipo da instância, define CPU, memória, etc.
  subnet_id              = aws_subnet.example_subnet.id       # Associa a instância à subnet.
  vpc_security_group_ids = [aws_security_group.example_sg.id] # Associa o Security Group à instância.

  tags = {
    Name = "example-instance"
  }
}

# Configura um Elastic Load Balancer para distribuir o tráfego entre instâncias EC2.
resource "aws_elb" "example_elb" {
  name    = "example-elb"
  subnets = [aws_subnet.example_subnet.id] # Define as subnets em que o ELB está localizado.

  # Define como o tráfego deve ser roteado para as instâncias.
  listener {
    instance_port     = 80 # Porta da instância para a qual o tráfego deve ser enviado.
    instance_protocol = "HTTP"
    lb_port           = 80 # Porta em que o ELB escuta.
    lb_protocol       = "HTTP"
  }

  instances = [aws_instance.example_instance.id] # Lista de instâncias EC2 que o ELB deve balancear.

  # Verifica a saúde das instâncias EC2.
  health_check {
    target              = "HTTP:80/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "example-elb"
  }
}

# Adiciona um Internet Gateway à VPC para permitir comunicação entre a VPC e a internet.
resource "aws_internet_gateway" "example_igw" {
  vpc_id = aws_vpc.example_vpc.id
  tags = {
    Name = "example-igw"
  }
}

# Cria uma tabela de rotas na VPC para direcionar o tráfego para o Internet Gateway.
resource "aws_route_table" "example_rt" {
  vpc_id = aws_vpc.example_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example_igw.id
  }
  tags = {
    Name = "example-route-table"
  }
}

# Associa a tabela de rotas criada à subnet.
resource "aws_route_table_association" "example_rta" {
  subnet_id      = aws_subnet.example_subnet.id
  route_table_id = aws_route_table.example_rt.id
}
