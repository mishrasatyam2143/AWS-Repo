#  Terraform Module: AWS Application Load Balancer (ALB)

This module provisions an Application Load Balancer (ALB) along with its required components: a Security Group, a default Target Group, and an HTTP Listener. This is designed to be easily integrated with EKS, ECS, or EC2 service deployments.

##  Module Contents

* `terraform/main.tf`: Core ALB, Security Group, Target Group, and Listener definitions.
* `terraform/variables.tf`: Configuration variables (VPC ID, Subnets, Name).
* `terraform/outputs.tf`: Exports the ALB DNS name and Target Group ARN for downstream use.

##  Deployment Example (Connecting ALB to VPC)

This example assumes your current Terraform root configuration is one directory above this module and that you have a working `vpc` module deployed (from `../VPC`).

### 1. Define the Variables

The following variables are required to deploy the ALB:

| Variable | Description | Example Value |
| :--- | :--- | :--- |
| `vpc_id` | ID of the parent VPC. | `module.vpc.vpc_id` |
| `subnet_ids` | IDs of the public subnets for the ALB. | `module.vpc.public_subnet_ids` |
| `environment` | Naming convention prefix. | `"staging"` |

### 2. Module Integration

Use the VPC module outputs to provide the necessary network context for the ALB.

**`alb.tf` (in your root config directory):**

```terraform
module "alb" {
  source  = "./Networking/LoadBalancers/terraform"
  version = "1.0.0"

  # REQUIRED VPC Inputs (from your VPC module output)
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnet_ids

  # REQUIRED SERVICE Inputs
  environment  = "dev"
  service_name = "website-frontend"

  # Optional Configuration
  alb_internal      = false
  listener_port     = 80
  listener_protocol = "HTTP"
  health_check_path = "/healthz"
}
