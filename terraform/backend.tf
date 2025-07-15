terraform {
  backend "s3" {
    bucket = "kenny-rails-terraform"
    key    = "terraform.tfstate"
    region = "eu-west-2"
    encrypt = true
  }
} 