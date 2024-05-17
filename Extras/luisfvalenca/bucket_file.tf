# This Terraform file defines the configuration for an AWS S3 bucket and related resources.

# Create an AWS S3 bucket
resource "aws_s3_bucket" "bucket" {
    bucket = "bucket-123ac321acs"

    tags = {
        Name        = "bucket-123ac321acs"
        Environment = "validando"
    }
}

# Define a bucket policy to allow public read access to objects in the bucket
resource "aws_s3_bucket_policy" "bucket_policy" {
    bucket = aws_s3_bucket.bucket.id

    policy = <<POLICY
{
    "Version":"2012-10-17",
    "Statement":[
        {
            "Sid":"AddPublicReadAccess",
            "Effect":"Allow",
            "Principal": "*",
            "Action":["s3:GetObject"],
            "Resource":["arn:aws:s3:::bucket-123ac321acs/*"]
        }
    ]
}
POLICY
}

# Configure public access block for the bucket
resource "aws_s3_bucket_public_access_block" "public_access_block" {
    bucket = aws_s3_bucket.bucket.id

    block_public_acls       = false
    block_public_policy     = false
    ignore_public_acls      = false
    restrict_public_buckets = false
}

# Configure website hosting for the bucket
resource "aws_s3_bucket_website_configuration" "website" {
    bucket = aws_s3_bucket.bucket.id
    index_document {
        suffix = "index.html"
    }
}

# Upload an HTML file to the bucket
resource "aws_s3_object" "html_file" {
    bucket       = aws_s3_bucket.bucket.id
    key          = "index.html"
    source       = "index.html"
    content_type = "text/html"
}
