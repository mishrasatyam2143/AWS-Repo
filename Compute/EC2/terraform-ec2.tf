# Terraform example - create an EC2 instance (minimal)
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1" # change to your region
}

resource "aws_key_pair" "example" {
  key_name   = "example-key"
  public_key = file("~/.ssh/id_rsa.pub") # ensure this file exists
}

resource "aws_instance" "example" {
  ami           = "ami-0123456789abcdef0" # replace with a valid AMI in your region
  instance_type = "t3.micro"
  key_name      = aws_key_pair.example.key_name

  tags = {
    Name = "example-ec2"
  }
}
