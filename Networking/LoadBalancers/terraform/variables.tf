```terraform
variable "vpc_id" {
  description = "The ID of the VPC where the Load Balancer will be deployed."
  type        = string
}

variable "subnet_ids" {
  description = "A list of public subnet IDs to deploy the ALB into. Must be at least two subnets in different AZs for high availability."
  type        = list(string)
}

variable "environment" {
  description = "The environment name (e.g., 'dev', 'staging') used for resource naming."
  type        = string
}

variable "service_name" {
  description = "The name of the service this ALB is routing traffic to (e.g., 'webapp', 'api')."
  type        = string
  default     = "default-service"
}

variable "alb_internal" {
  description = "Whether the ALB should be internal (true) or internet-facing (false)."
  type        = bool
  default     = false
}

variable "listener_port" {
  description = "The port the ALB Listener will open (e.g., 80 or 443)."
  type        = number
  default     = 80
}

variable "listener_protocol" {
  description = "The protocol for the ALB Listener (HTTP or HTTPS)."
  type        = string
  default     = "HTTP"
}

variable "health_check_path" {
  description = "The path for the target group health check (e.g., /healthz)."
  type        = string
  default     = "/"
}
