provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

module "ec2_instance" {
  source        = "./ec2_module"
  ami_id        = "ami-0e3a6d8ff4c8fe246"
  instance_type = "t3.micro"
}

module "s3_bucket" {
  source      = "./s3_module"
  bucket_name = "${var.project_name}-${random_id.bucket_suffix.hex}"
}

module "s3_bucket_1" {
  source      = "./s3_module"
  bucket_name = "${var.project_name}-${random_id.bucket_suffix.hex}"
}

resource "random_id" "bucket_suffix" {
  byte_length = 2
}
