# Attach an EC2 instance to the ALB Target Group
resource "aws_lb_target_group_attachment" "app_attachment" {
  target_group_arn = module.alb.target_group_arn
  target_id        = aws_instance.my_app_server.id
  port             = 80
}

output "frontend_url" {
  value = "http://${module.alb.alb_dns_name}"
}
