output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer, used for external access or Route 53 CNAME records."
  value       = aws_lb.main.dns_name
}

output "target_group_arn" {
  description = "The ARN of the main Target Group. Used to register EC2/EKS/ECS targets."
  value       = aws_lb_target_group.main.arn
}

output "alb_security_group_id" {
  description = "The ID of the Security Group associated with the ALB. Can be referenced by backend services to allow inbound traffic."
  value       = aws_security_group.alb_sg.id
}
