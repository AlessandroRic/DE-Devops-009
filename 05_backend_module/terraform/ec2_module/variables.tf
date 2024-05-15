variable "ami_id" {
  description = "The AMI ID to use for the instance."
}

variable "instance_type" {
  description = "The type of instance to start."
  default     = "t2.micro"
}
