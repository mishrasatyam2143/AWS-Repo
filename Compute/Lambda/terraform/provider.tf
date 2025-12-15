terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider in a default region
provider "aws" {
  region = "us-east-1" # Change to your preferred region
}
