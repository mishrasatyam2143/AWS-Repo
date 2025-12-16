#  AWS Load Balancers: Architecture and Selection Guide

AWS Elastic Load Balancing (ELB) is a critical service for distributing incoming application traffic across multiple targets, such as EC2 instances, containers, IP addresses, and Lambda functions, ensuring fault tolerance and scaling.

## 1. Choosing Your Load Balancer

AWS provides three primary types of load balancers: Application Load Balancer (ALB), Network Load Balancer (NLB), and Gateway Load Balancer (GLB).

| Type | Layer | Best Used For | Key Features |
| :--- | :--- | :--- | :--- |
| **ALB (Application Load Balancer)** | Layer 7 (HTTP/HTTPS) | Flexible routing, microservices, containerized applications (EKS/ECS). | Content-based routing, host/path rules, user authentication, WAF integration. |
| **NLB (Network Load Balancer)** | Layer 4 (TCP/UDP) | Extreme performance, fixed IP addresses, very low latency (sub-100ms). | Static IP addresses, preservation of client source IP, high throughput. |
| **GLB (Gateway Load Balancer)** | Layer 3 (IP) | Routing traffic to virtual appliances (firewalls, intrusion detection systems). | Transparent network gateway, allows third-party vendors to be inserted into the network path. |

**When to Choose ALB (Your Current Module Focus):**
Use an ALB when you need intelligent routing based on the content of the request, such as routing `/api/v1/*` to one set of targets and `/images/*` to another. It is the standard choice for web applications and container platforms like Kubernetes (EKS).

## 2. Core ALB Components and Traffic Flow

An ALB acts as the single point of contact for clients. It relies on four main components to function:

### A. Load Balancer (The Frontend)
This is the public-facing component that distributes the load.

* **DNS Name:** The ALB is accessed via a high-availability DNS record provided by AWS (e.g., `my-alb-1234.us-east-1.elb.amazonaws.com`).
* **Availability Zones:** ALBs must be deployed across at least two subnets in two different Availability Zones (AZs) to ensure high availability.
* **Internet-facing vs. Internal:** An ALB can be Internet-facing (accessible via public IP addresses) or internal (accessible only via private IP addresses within the VPC).

### B. Security Group
The ALB must be associated with a Security Group that defines what traffic is allowed *into* the load balancer (e.g., TCP/80 and TCP/443 from `0.0.0.0/0`).

### C. Listener (The Door)
A Listener is a process that checks for connection requests on a configurable protocol and port.

* **Port/Protocol:** Common listeners are set up for HTTP (80) or HTTPS (443).
* **Rules:** Listeners evaluate rules in order, from highest priority to lowest, to determine where to route traffic.
    * *Example Rule:* IF **Host** is `api.example.com` AND **Path** is `/v2/*`, THEN **Forward** to `API-Target-Group`.
* **Default Action:** Every listener must have a default action that is triggered if no other rule matches.

### D. Target Group (The Back-end Pool)
A Target Group acts as a logical grouping of the destination targets (EC2 instances, EKS Pods, etc.) and is responsible for health checks.

* **Targets:** Targets are registered to the group, usually by their IP address or instance ID.
* **Health Checks:** The target group defines parameters for health checks (e.g., path `/healthz`, port `80`, interval `30s`). The ALB only forwards traffic to targets that pass these health checks.
* **Deregistration Delay:** A period during which the ALB attempts to complete in-flight requests before terminating the connection to a target that is being deregistered (e.g., during a deployment).
