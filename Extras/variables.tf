variable "region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project to create resources for"
  default     = "nginx-on-ecs"
}

variable "aws_access_key" {
  description = "Access Key ID da AWS"
  type        = string
}

variable "aws_secret_key" {
  description = "Secret Access Key da AWS"
  type        = string
}
