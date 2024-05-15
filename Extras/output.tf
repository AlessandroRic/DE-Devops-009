output "alb_dns_name" {
  value = aws_lb.ecs_alb.dns_name
  description = "The DNS name for the application load balancer"
}
