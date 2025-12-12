# AWS EC2 Instance Provisioning (Single-File Terraform)

This is a complete, single-file example (`terraform-ec2.tf`) to provision a basic EC2 instance on AWS. It sets up a Security Group, creates an SSH Key Pair, and runs a simple `cloud-init` script to install Nginx.

---

## Quick Start Instructions

You must pass the path to your public SSH key and your IP address (for SSH access) as variables.

###  Required Variables

| Variable | Description | Default Value | Action Needed |
| :--- | :--- | :--- | :--- |
| `public_key_path` | **Absolute path** to your public SSH key (e.g., `/home/user/.ssh/id_rsa.pub`). | `""` | **MUST OVERRIDE** |
| `ssh_cidr` | CIDR allowed for SSH access (use your public IP, e.g., `203.0.113.5/32`). Default is open to the world. | `"0.0.0.0/0"` | **SHOULD OVERRIDE** |

### Usage Commands

1.  **Initialize Terraform:**
    ```bash
    terraform init
    ```

2.  **Plan the Deployment (Validation):**
    Review the plan to ensure no unintended resources are created, modified, or destroyed.
    ```bash
    terraform plan \
      -var "public_key_path=/home/user/.ssh/id_rsa.pub" \
      -var "ssh_cidr=203.0.113.5/32"
    ```

3.  **Apply the Configuration:**
    ```bash
    terraform apply \
      -var "public_key_path=/home/user/.ssh/id_rsa.pub" \
      -var "ssh_cidr=203.0.113.5/32"
    ```
    
4.  **Destroy Resources (Cleanup):**
    ```bash
    terraform destroy \
      -var "public_key_path=/home/user/.ssh/id_rsa.pub" \
      -var "ssh_cidr=203.0.113.5/32"
    ```

---

## 💻 `terraform-ec2.tf` File Contents

### HCL Configuration

```hcl
# ----------------------------
# Variables (change as needed)
# ----------------------------
variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "ami_id" {
  description = "AMI ID to use for the instance (optional). If empty, Terraform looks up a recent Amazon Linux 2 AMI."
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name to give the created key pair resource (or use existing key name)"
  type        = string
  default     = "example-key"
}

variable "public_key_path" {
  description = "Absolute path to SSH public key (e.g. /home/user/.ssh/id_rsa.pub). Required."
  type        = string
  default     = ""
  validation {
    condition     = length(var.public_key_path) > 0
    error_message = "Set public_key_path to the absolute path of your public SSH key before apply."
  }
}

variable "private_key_path" {
  description = "Private key path used in the ssh_command output (for convenience). Provide absolute path if desired."
  type        = string
  default     = "~/.ssh/id_rsa"
}

variable "instance_name" {
  description = "Name tag for the instance"
  type        = string
  default     = "terraform-example-ec2"
}

variable "ssh_cidr" {
  description = "CIDR allowed for SSH (use your IP, e.g. 203.0.113.5/32). Default opens to all — override in production."
  type        = string
  default     = "0.0.0.0/0"
}

variable "subnet_id" {
  description = "Optional subnet id (leave empty to use default subnet)"
  type        = string
  default     = ""
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
# AMI data source (fallback)
# ----------------------------
# If var.ami_id is empty, use a recent Amazon Linux 2 AMI for the region.
data "aws_ami" "amazon_linux2" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  owners = ["amazon"]
}

# ----------------------------
# Security Group (basic)
# ----------------------------
resource "aws_security_group" "ec2_sg" {
  name        = "${var.instance_name}-sg"
  description = "Allow SSH (limited via var.ssh_cidr) and HTTP"
  # Uncomment to set a specific VPC: vpc_id = "vpc-xxxxxxxx"

  ingress {
    description = "SSH from allowed CIDR"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr]
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
# Terraform reads your public key and registers it as an AWS key pair.
resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

# ----------------------------
# EC2 Instance
# ----------------------------
resource "aws_instance" "example" {
  ami             = var.ami_id != "" ? var.ami_id : data.aws_ami.amazon_linux2.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  # Use a specific subnet if provided, otherwise leave AWS to pick a default
  subnet_id = var.subnet_id != "" ? var.subnet_id : null

  # Hardening: require IMDSv2
  metadata_options {
    http_tokens = "required"
  }

  # Simple cloud-init: install nginx (works on Amazon Linux and Debian/Ubuntu)
  user_data = <<-EOF
              #!/bin/bash
              set -eux
              if grep -qi "amzn" /etc/os-release 2>/dev/null; then
                yum update -y
                yum install -y nginx
                systemctl enable --now nginx
              elif [ -f /etc/debian_version ]; then
                apt-get update -y
                apt-get install -y nginx
                systemctl enable --now nginx
              fi
              EOF

  tags = {
    Name        = var.instance_name
    Environment = "dev"
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 8
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
  description = "Example ssh command to connect (replace private key path if needed)"
  value       = "ssh -i ${var.private_key_path} ec2-user@${aws_instance.example.public_ip}"
}
