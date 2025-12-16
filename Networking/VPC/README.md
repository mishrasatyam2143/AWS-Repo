```markdown
#  VPC Terraform Module: Highly Available Network Guide

This directory contains a reusable Terraform module for provisioning a standard, highly available AWS VPC network.

##  Module Structure Overview

* `terraform/main.tf`: Defines all core VPC resources, including the VPC, IGW, NAT Gateway, EIP, and all subnets and route tables.
* `terraform/variables.tf`: Allows customization of the VPC CIDR block and resource naming via the `environment` variable.
* `terraform/outputs.tf`: Exports the IDs of critical resources (VPC ID, subnet IDs) necessary for other modules (like EC2, RDS, or EKS) to integrate with this network.

##  Module Features and Topology

This module creates a **secure, two-tier network topology** across two Availability Zones (AZs):

| Resource Type | Count | Purpose | IP Allocation |
| :--- | :--- | :--- | :--- |
| **VPC** | 1 | Defines the network boundary (e.g., 10.0.0.0/16). | Configured via `vpc_cidr_block` |
| **Public Subnets** | 2 | Hosts Load Balancers and NAT Gateway. | `10.0.0.0/24`, `10.0.1.0/24` |
| **Private Subnets** | 2 | Hosts Application Servers (EC2/EKS Nodes) and Databases. | `10.0.10.0/24`, `10.0.11.0/24` |
| **NAT Gateway** | 1 | Enables outbound internet access for Private Subnets. | Placed in Public Subnet 1 |
| **Route Tables** | 2 | One Public (routes to IGW), one Private (routes to NAT Gateway). | Automatically associated |

##  Deployment Instructions

1.  **Review Variables:** Check the default values in `terraform/variables.tf`.
    ```bash
    cat terraform/variables.tf
    ```
2.  **Navigate and Init:**
    ```bash
    cd terraform
    terraform init
    ```
3.  **Validate and Plan:** Review the resources to be created.
    ```bash
    terraform validate
    terraform plan
    ```
4.  **Deploy:**
    ```bash
    terraform apply
    ```

##  Integration (How to Use This VPC)

To launch an EC2 instance into this VPC, you would reference the module's outputs in your EC2 Terraform code:

```terraform
module "vpc" {
  source = "../../Networking/VPC/terraform"
  # ... other variables
}

resource "aws_instance" "app" {
  # Launch the instance into one of the exported private subnets
  subnet_id = module.vpc.private_subnet_ids[0] 
  # ...
}
