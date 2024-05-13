output "bucket_name" {
  value = aws_s3_bucket.bucket.bucket
  description = "O nome do bucket criado"
}
