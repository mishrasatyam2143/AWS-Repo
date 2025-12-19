```terraform
variable "domain_name" {
  description = "The primary domain name (e.g., example.com)"
  type        = string
}

variable "subdomain" {
  description = "The subdomain to create (e.g., 'app' for app.example.com)"
  type        = string
  default     = "www"
}

variable "target_dns_name" {
  description = "The DNS name of the target resource (usually an ALB DNS name)"
  type        = string
}

variable "target_zone_id" {
  description = "The Hosted Zone ID of the target resource (required for Alias records)"
  type        = string
}
