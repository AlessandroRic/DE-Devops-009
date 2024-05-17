variable "region" {
  type    = string
  default = "us-east-1"
}

variable "aws_access_key" {
  description = "Access Key ID da AWS"
  type        = string
}

variable "aws_secret_key" {
  description = "Secret Access Key da AWS"
  type        = string
}

variable "ami_id" {
  description = "ID da AMI"
  type        = string
}