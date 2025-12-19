# 1. Create the Public Hosted Zone
resource "aws_route53_zone" "main" {
  name = var.domain_name

  tags = {
    Environment = "production"
  }
}

# 2. Create an Alias Record pointing to a Load Balancer
# Alias records are preferred over CNAMEs for AWS resources
resource "aws_route53_record" "app" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "${var.subdomain}.${var.domain_name}"
  type    = "A" # Alias records use 'A' type but behave like a pointer

  alias {
    name                   = var.target_dns_name
    zone_id                = var.target_zone_id
    evaluate_target_health = true
  }
}
