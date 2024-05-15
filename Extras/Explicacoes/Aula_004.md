---
marp: true
---

# **Página: Gerenciamento de Infraestrutura com Terraform - AWS ECS**

---

## **Introdução ao Terraform e AWS ECS**
Explique brevemente o que é Terraform e AWS ECS e o objetivo da aula.

---

## **Componentes do Projeto Terraform**
Cada seção abaixo corresponde a um arquivo ou conceito dentro do projeto Terraform.

---

## **1. provider.tf**
- **Objetivo:** Define o provedor de serviços de nuvem (AWS, neste caso) e a região onde os recursos serão implantados.
- **Importância:** O Terraform precisa saber com qual provedor de infraestrutura ele está interagindo para configurar os recursos apropriados com as APIs corretas. A região especifica onde os recursos serão fisicamente criados, impactando a latência e a conformidade legal.

---

## **2. variables.tf**
- **Objetivo:** Declara variáveis que serão usadas em todo o projeto para permitir personalização e reutilização do código sem hardcoding.
- **Importância:** Variáveis tornam os templates mais flexíveis e menos propensos a erros. Elas permitem que você personalize o ambiente sem alterar o código principal, facilitando, por exemplo, o lançamento de múltiplos ambientes como desenvolvimento, teste e produção.

---

## **3. vpc.tf**
- **Objetivo:** Configura a rede virtual (VPC), subnets e o Internet Gateway necessários para que os recursos na nuvem possam se comunicar com a internet e entre si de forma segura.
- **Importância:** Uma VPC oferece isolamento de rede, o que é crucial para segurança, eficiência e gerenciamento de custos. Subnets permitem segmentar a rede em partes mais gerenciáveis e seguras. O Internet Gateway permite a comunicação entre os recursos da AWS na VPC e a internet.

---

## **4. security-group.tf**
- **Objetivo:** Define as regras de segurança que permitem ou negam o tráfego de rede para os serviços na VPC.
- **Importância:** Security groups atuam como um firewall virtual para seus recursos na nuvem, controlando o acesso de entrada e saída para instâncias, garantindo que apenas tráfego autorizado possa acessar os serviços.

---

## **5. ecs-cluster.tf**
- **Objetivo:** Define a Task Definition e o ECS Service para gerenciar e executar instâncias do container Nginx na infraestrutura definida.
- **Importância:** Task Definitions especificam como os containers devem ser executados, incluindo suas imagens, CPU, memória e configurações de rede. O ECS Service mantém o número especificado de instâncias de uma task definition em execução, gerenciando o ciclo de vida e garantindo a disponibilidade.

---

## **6. ecs-service.tf**
- **Objetivo:** Define a Task Definition e o ECS Service.
- **Importância:** Gerencia o ciclo de vida das aplicações containerizadas, mantendo a disponibilidade e escalabilidade.

---

## **7. outputs.tf**
- **Objetivo:** Especifica os dados que serão retornados após a aplicação dos templates do Terraform, como IPs públicos dos serviços.
- **Importância:** Outputs são úteis para obter informações importantes sobre os recursos implantados, que podem ser usados para debugging, configurações adicionais ou como entradas para outros templates e serviços.
