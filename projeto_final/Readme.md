### **Solicitação de Projeto para Conclusão de Módulo de Terraform**

---

**Objetivo Geral:**
Desenvolver e implementar um módulo Terraform que provisione um ambiente contendo um serviço Dockerizado em AWS ECS ou EKS. O projeto deve demonstrar uma compreensão completa dos conceitos fundamentais de Terraform e da plataforma AWS, integrando vários serviços para fornecer uma solução robusta e escalável.

**Descrição do Projeto:**
1. **Provisionamento de Serviços AWS:**
   - Configurar uma VPC, subnets, gateways, e tabelas de roteamento adequadas para um ambiente de produção.
   - Implementar o serviço AWS ECS ou EKS para hospedar uma aplicação em Docker, que deverá ser disponibilizada de forma automática através do código Terraform.
   - Criar e configurar serviços auxiliares como ELB (Elastic Load Balancing), RDS para bancos de dados, e S3 para armazenamento de logs ou dados estáticos.

2. **Módulo Terraform:**
   - Desenvolver um módulo Terraform que encapsule a lógica para lançar um serviço de contêiner, seja utilizando ECS com Fargate ou um cluster EKS.
   - O módulo deve permitir a configuração flexível dos parâmetros do serviço, incluindo configurações de rede, segurança e auto-scaling.

3. **Backend e Workspace:**
   - Utilizar S3 e DynamoDB como backend para gerenciar o estado do Terraform, facilitando o trabalho colaborativo entre a equipe.
   - Configurar diferentes workspaces para simular ambientes de desenvolvimento, teste e produção, demonstrando a habilidade de gerenciar múltiplos ambientes com Terraform.

4. **Documentação:**
   - Fornecer documentação completa do código, incluindo comentários sobre as escolhas de configuração e instruções detalhadas sobre como inicializar e aplicar o projeto.

**Critérios de Avaliação:**
- **Correção Técnica:** O ambiente deve ser provisionado sem erros e todas as configurações devem ser aplicadas como definido no projeto.
- **Boas Práticas:** Uso de boas práticas de codificação em Terraform, incluindo o uso adequado de módulos, variáveis, e estruturação do código.
- **Inovação e Complexidade:** Uso criativo e eficaz dos recursos do Terraform e da AWS para resolver o problema proposto.
- **Documentação e Explicação:** Clareza na documentação e na capacidade de explicar e justificar as escolhas feitas durante o desenvolvimento do projeto.

**Entrega Final:**
- Documentação em formato markdown junto com o código.
- Apresentação ao vivo demonstrando a utilização do projeto, explicando o código e as escolhas de design.