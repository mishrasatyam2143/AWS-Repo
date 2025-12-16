variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "environment" {
  description = "Environment tag (e.g., dev, stage, prod)."
  type        = string
  default     = "dev"
}
