output "ec2_instance_id" {
  value = module.ec2_instance.instance_id
}

output "s3_bucket_arn" {
  value = module.s3_bucket.bucket_arn
}
