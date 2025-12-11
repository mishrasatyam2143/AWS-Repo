# EC2

This folder contains quick guides and examples for EC2.

## Files
- [EC2 Basics](ec2-basics.md) - conceptual overview and common concepts.
- [EC2 CLI Commands](ec2-cli-commands.md) - cheat sheet for common `aws ec2` commands.
- [Terraform example](terraform-ec2.tf) - minimal Terraform example to create an EC2 instance.

## Quick start
1. Read `ec2-basics.md` to understand concepts.
2. Use `ec2-cli-commands.md` for hands-on CLI practice.
3. Review `terraform-ec2.tf` before running `terraform init` / `plan` (replace AMI and keys).

## Notes
- Do not commit secrets or private keys.
- Use a low-cost instance type (t3.micro) when experimenting.
