---
marp: true
---

# **ecs-cluster & ecs-service**

ECS (Elastic Container Service) da AWS usando Terraform.

---

### **Cluster**

```hcl
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.project_name}-cluster"
  tags = {
    Name = "${var.project_name}-cluster"
  }
}
```

**Explicação:**
- **aws_ecs_cluster**: Este recurso do Terraform cria um cluster do ECS, que é uma coleção lógica de tarefas ou serviços. Pense no cluster como um "data center virtual" onde você pode executar suas aplicações containerizadas.

- **tags**: Usado para adicionar metadados ao cluster, ajudando na identificação e organização dos recursos dentro da AWS.

---

### **Cluster Services (LB)**

```hcl
resource "aws_lb" "ecs_alb" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecs_sg.id]
  subnets            = [for subnet in aws_subnet.ecs_subnet : subnet.id]
  tags = {
    Name = "${var.project_name}-alb"
  }
}
```

**Explicação:**
- **aws_lb**: Define um Application Load Balancer (ALB) que distribui automaticamente o tráfego de entrada para múltiplas tarefas executadas dentro do cluster ECS, baseadas em regras e condições definidas.

---

```hcl
resource "aws_lb_target_group" "ecs_tg" {
  name     = "${var.project_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.ecs_vpc.id
  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}
```

**Explicação:**
- **aws_lb_target_group**: Grupo de destino que é usado para rotear requisições para um ou mais portos registrados sob ele. Aqui, estamos definindo que todas as requisições HTTP na porta 80 devem ser tratadas por este grupo.

---

```hcl
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }
}
```
**Explicação:**

- **aws_lb_listener**: Ouvinte que verifica as conexões de entrada e as encaminha para um target group baseado em regras definidas (aqui, simplesmente encaminha todo o tráfego HTTP na porta 80).

---

## **Task Definition & Service**
```hcl
resource "aws_ecs_task_definition" "nginx" {
  family                   = "nginx"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  container_definitions    = jsonencode([
    {
      name        = "nginx"
      image       = "nginx:latest"
      essential   = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}
```

---

```hcl
resource "aws_ecs_service" "nginx_service" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.nginx.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    container_name   = "nginx"
    container_port   = 80
  }
  network_configuration {
    subnets          = [for subnet in aws_subnet.ecs_subnet : subnet.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
  depends_on = [
    aws_lb_listener.front_end
  ]
}
```

---

**Explicação:**
- **aws_ecs_task_definition**: Define a receita para rodar um container específico

. Neste caso, é o Nginx na porta 80. Define também os recursos necessários como CPU e memória.
- **aws_ecs_service**: Serviço que mantém o número especificado de instâncias de uma task definition em execução e reage de acordo com as políticas definidas (aqui, mantém sempre uma instância rodando).
- **network_configuration**: Configurações de rede para garantir que a task possa se comunicar dentro da VPC e ser acessível externamente.
- **depends_on**: Garante que os listeners do ALB estejam configurados antes que o serviço ECS tente registrar-se neles.