variable "key_name" {
  description = "The name of the EC2 key pair to use for SSH access"
  type        = string
}

variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "The EC2 instance type to use"
  type        = string
  default     = "t2.medium"
}

variable "ami_id" {
  description = "The AMI ID to use (Ubuntu 22.04 LTS)"
  type        = string
  default     = "ami-020cba7c55df1f615" # Ubuntu 22.04 LTS in eu-west-2
} 
