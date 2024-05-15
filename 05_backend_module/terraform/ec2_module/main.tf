resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags = {
    Name = "ExampleInstance"
  }
}
