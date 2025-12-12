###############################################################################
# terraform-ec2.tf
#
# Single-file, self-documented Terraform example to create a simple EC2 instance.
# Suitable for learning and small demos. Replace AMI, region and key path before apply.
#
# Important: This example creates network and compute resources in your AWS account.
# Running it will incur charges. Destroy when finished: `terraform destroy`.
#
# Usage:
#   terraform init
#   terraform plan -var "public_key_path=~/.ssh/id_rsa.pub" -var "ami_id=ami-xxxx"
#   terraform apply -var "public_key_path=~/.ssh/id_rsa.pub" -var "ami_id=ami-xxxx"
#
###############################################################################

# ----------------------------
# Variables (change as needed)
# ----------------------------
variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "ami_id" {
  description = "AMI ID to use for the instance (replace with a valid AMI in your region)"
  type        = string
  default     = "ami-0123456789abcdef0"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name to give the created key pair resource"
  type        = string
  default     = "example-key"
}

variable "public_key_path" {
  description = "Path to the SSH public key that will be uploaded as key pair"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "instance_name" {
  description = "Name tag for the instance"
  type        = string
  default     = "terraform-example-ec2"
}

# ----------------------------
# Terraform / Provider block
# ----------------------------
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# ----------------------------
# Minimal VPC networking note
# ----------------------------
# This example uses the default VPC in the region. For production, create a
# dedicated VPC, subnets, IGW, NAT and security controls.
#
# Get default VPC id:
#   aws ec2 describe-vpcs --filters "Name=isDefault,Values=true" --query "Vpcs[0].VpcId" --output text
#
# Optionally set a subnet id using the 'subnet_id' variable (not included here).

# ----------------------------
# Security Group (basic)
# ----------------------------
resource "aws_security_group" "ec2_sg" {
  name        = "${var.instance_name}-sg"
  description = "Allow SSH and HTTP"
  # Using default VPC; change vpc_id for custom VPCs
  # vpc_id = "vpc-xxxxxxxx"

  ingress {
    description = "SSH from local IP (update before production)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # Replace with your IP/CIDR for better security, e.g. "203.0.113.5/32"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.instance_name}-sg"
  }
}

# ----------------------------
# Key pair using local public key
# ----------------------------
# This reads your public key from the path provided in var.public_key_path and
# creates an aws_key_pair resource (the private key remains on your machine).
resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

# ----------------------------
# EC2 Instance
# ----------------------------
# This is a simple example that creates one instance in the default subnet.
# It attaches the security group and key pair defined above.
resource "aws_instance" "example" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  # Optional user_data for simple bootstrap (cloud-init)
  user_data = <<-EOF
              #!/bin/bash
              # Simple bootstrap: install nginx
              yum update -y || apt-get update -y
              if command -v yum >/dev/null 2>&1; then
                yum install -y nginx
                systemctl enable nginx
                systemctl start nginx
              else
                apt-get install -y nginx
                systemctl enable nginx
                systemctl start nginx
              fi
              EOF

  tags = {
    Name = var.instance_name
    Environment = "dev"
  }

  # Block device mapping example: keep root volume small
  root_block_device {
    volume_type = "gp3"
    volume_size = 8
    delete_on_termination = true
  }
}

# ----------------------------
# Outputs
# ----------------------------
output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.example.id
}

output "public_ip" {
  description = "Public IP assigned to the instance"
  value       = aws_instance.example.public_ip
}

output "ssh_command" {
  description = "Example ssh command to connect (use your private key)"
  value       = "ssh -i ~/.ssh/id_rsa ec2-user@${aws_instance.example.public_ip}"
}

###############################################################################
# Notes and recommended changes before running:
# 1) Replace variable default `ami_id` with a valid AMI for your region.
# 2) Change security group cidr_blocks from 0.0.0.0/0 to your IP for SSH.
# 3) If you do not have a default VPC or want a specific subnet, add subnet_id
#    attribute to the aws_instance resource: subnet_id = "subnet-xxxxx"
# 4) For production, move variables to variables.tf and use a remote state backend.
###############################################################################

