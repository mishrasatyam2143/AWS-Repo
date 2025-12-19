# Terraform Module: Route 53 DNS Management

This module manages AWS Route 53 Hosted Zones and DNS records. It is designed to work seamlessly with the **LoadBalancers** module by using Alias records.

## Module Contents

* `terraform/main.tf`: Defines the Hosted Zone and Alias/CNAME records.
* `terraform/variables.tf`: Input for your domain name and target resource.
* `terraform/outputs.tf`: Exports the Name Servers (NS) which you must provide to your domain registrar.

## Deployment and Integration

### Step 1: Link to Load Balancer
This module is typically used to point a friendly URL (like `api.example.com`) to an ALB's DNS name.

**`dns.tf` (in your project root):**

```terraform
module "dns" {
  source = "./Networking/Route53/terraform"

  domain_name = "example.com"
  subdomain   = "app"
  
  # Integration with LoadBalancer Module
  target_dns_name    = module.alb.alb_dns_name
  target_zone_id     = module.alb.alb_zone_id # Required for Alias records
}
```

---
## Step 2: Configure Your Registrar

After provisioning, Route 53 provides a set of four unique Name Servers. You must log in to your domain registrar (e.g., GoDaddy, Namecheap) and update the DNS settings to 
use these AWS Name Servers.
---

## Step 3: Verification
Once the DNS propagates, verify the mapping using the dig command:

```
dig +short app.example.com
```

---
## Requirements

| Name      | Version   |
|-----------|-----------|
| terraform | >= 1.0.0  |
| aws       | >= 5.0.0  |
 
