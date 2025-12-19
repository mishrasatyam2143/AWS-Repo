output "hosted_zone_id" {
  description = "The ID of the Hosted Zone"
  value       = aws_route53_zone.main.zone_id
}

output "name_servers" {
  description = "The Name Servers for the Hosted Zone. Provide these to your domain registrar."
  value       = aws_route53_zone.main.name_servers
}
