# --- 1. ALB Security Group ---
resource "aws_security_group" "alb_sg" {
  name        = "${var.environment}-${var.service_name}-alb-sg"
  description = "Security group for the Application Load Balancer."
  vpc_id      = var.vpc_id

  # Inbound Rule: Allow traffic on the listener port from anywhere (0.0.0.0/0)
  # For internal ALBs, traffic is allowed from inside the VPC
  ingress {
    from_port   = var.listener_port
    to_port     = var.listener_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  # Outbound Rule: Allow all outbound traffic (ALB needs this to talk to Target Groups)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-${var.service_name}-alb-sg"
    Environment = var.environment
  }
}

# --- 2. Application Load Balancer (ALB) ---
resource "aws_lb" "main" {
  name               = "${var.environment}-${var.service_name}-alb"
  internal           = var.alb_internal
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = [aws_security_group.alb_sg.id]

  # Recommended best practice
  enable_deletion_protection = true

  tags = {
    Name        = "${var.environment}-${var.service_name}-alb"
    Environment = var.environment
  }
}

# --- 3. Default Target Group ---
# This TG will receive all default traffic from the listener
resource "aws_lb_target_group" "main" {
  name     = "${var.environment}-${var.service_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = var.health_check_path
    protocol            = "HTTP"
    port                = "traffic-port" # Check targets on the port they receive traffic
    matcher             = "200-399"      # Success codes
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name        = "${var.environment}-${var.service_name}-tg"
    Environment = var.environment
  }
}

# --- 4. Default Listener ---
# A listener is required to route traffic to the Target Group
resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}
