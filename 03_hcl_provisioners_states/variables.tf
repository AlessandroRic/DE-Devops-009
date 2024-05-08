variable "aws_region" {
  description = "Região da AWS para provisionar os recursos"
  type        = string
  default     = "us-east-1"
}

variable "aws_access_key" {
  description = "Access Key ID da AWS"
  type        = string
}

variable "aws_secret_key" {
  description = "Secret Access Key da AWS"
  type        = string
}

variable "bucket_name" {
  description = "Nome único do Bucket S3"
  type        = string
}
