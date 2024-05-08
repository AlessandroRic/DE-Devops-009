resource "aws_s3_bucket" "meu_bucket" {
  bucket = var.bucket_name

  tags = {
    Nome = "Meu Bucket Terraform"
  }
}