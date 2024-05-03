# Provedor AWS
provider "aws" {
    access_key                  = "mock_access_key"  # Chave de acesso para autenticar na AWS
    secret_key                  = "mock_secret_key"  # Chave secreta para autenticar na AWS
    region                      = "us-east-1"  # Região da AWS onde os recursos serão provisionados
    s3_use_path_style           = true  # Define o estilo de URL para acessar o serviço S3
    skip_credentials_validation = true  # Ignora a validação das credenciais de autenticação
    skip_metadata_api_check     = true  # Ignora a verificação da API de metadados
    skip_requesting_account_id  = true  # Ignora a solicitação do ID da conta
    endpoints {
        s3 = "http://s3.localhost.localstack.cloud:4566"  # URL do serviço S3 -> para acessar o index do LocalStack basta adicionar /bucket1/index.html
    }
}

# Recurso Bucket S3
resource "aws_s3_bucket" "bucket1" {
    bucket = "bucket1"  # Nome do bucket S3
    website {
        index_document = "index.html"  # Documento de índice para o bucket S3
    }
}

# Recurso Objeto do Bucket S3
resource "aws_s3_bucket_object" "html_file" {
    bucket       = aws_s3_bucket.bucket1.id  # ID do bucket S3
    key          = "index.html"  # Chave do objeto no bucket S3
    source       = "index.html"  # Caminho do arquivo de origem
    acl          = "public-read"  # Permissões de acesso ao objeto
    content_type = "text/html"  # Tipo de conteúdo do objeto
}

# Política do Bucket S3
resource "aws_s3_bucket_policy" "bucket_policy" {
    bucket = aws_s3_bucket.bucket1.id  # ID do bucket S3
    policy = jsonencode({
        Version = "2012-10-17"  # Versão da política
        Statement = [
            {
                Effect    = "Allow"  # Efeito da política
                Principal = "*"  # Principal da política
                Action    = "s3:GetObject"  # Ação permitida pela política
                Resource  = "${aws_s3_bucket.bucket1.arn}/*"  # Recurso ao qual a política se aplica
            }
        ]
    })
}