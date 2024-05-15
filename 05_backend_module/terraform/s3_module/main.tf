resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_public_access_block" "access_block" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls   = true
  block_public_policy = true
}