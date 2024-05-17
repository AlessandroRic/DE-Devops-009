output "aws_instance_id" {
  value = aws_instance.example_instance.id
}

output "aws_instance_public_ip" {
  value = aws_instance.example_instance.public_ip
}

output "aws_instance_private_ip" {
  value = aws_instance.example_instance.private_ip
}

output "aws_instance_public_dns" {
  value = aws_instance.example_instance.public_dns
}

output "aws_instance_private_dns" {
  value = aws_instance.example_instance.private_dns
}

output "aws_instance_instance_state" {
  value = aws_instance.example_instance.instance_state
}

output "aws_instance_availability_zone" {
  value = aws_instance.example_instance.availability_zone
}

output "aws_instance_key_name" {
  value = aws_instance.example_instance.key_name
}

output "aws_instance_subnet_id" {
  value = aws_instance.example_instance.subnet_id
}

output "aws_instance_vpc_security_group_ids" {
  value = aws_instance.example_instance.vpc_security_group_ids
}

output "aws_instance_instance_type" {
  value = aws_instance.example_instance.instance_type
}

output "aws_instance_ami" {
  value = aws_instance.example_instance.ami
}