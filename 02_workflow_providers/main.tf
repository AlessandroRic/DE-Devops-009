provider "aws" {
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    ec2 = "http://localhost:4566"
  }
}

resource "aws_instance" "localstack_ec2" {
  ami           = "ami-0c55b159cbfafe1f0"  # Dummy AMI ID
  instance_type = "t2.micro"               # Escolha qualquer tipo, pois é apenas para simulação

  tags = {
    Name = "LocalStack EC2 Example"
  }
}

