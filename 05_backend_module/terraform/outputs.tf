output "ec2_instance_id" {
  value = module.ec2_instance.instance_id
}

output "ec2_instance_public_ip" {
  value = module.ec2_instance.public_ip
}

output "ec2_instance_private_ip" {
  value = module.ec2_instance.private_ip
}

output "ec2_instance_state" {
  value = module.ec2_instance.state
}

output "s3_bucket_arn" {
  value = module.s3_bucket.bucket_arn
}

output "s3_bucket_id" {
  value = module.s3_bucket.bucket_id
}

output "s3_bucket_region" {
  value = module.s3_bucket.region
}

output "s3_bucket_acl" {
  value = module.s3_bucket.acl
}