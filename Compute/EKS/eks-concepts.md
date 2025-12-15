#  EKS Conceptual Deep Dive

## 1. EKS Architecture Overview

EKS separates the management of the **Control Plane** from the **Data Plane (Worker Nodes)**. 

* **Control Plane:** AWS manages the API Server, etcd, Scheduler, and Controller Manager. This is highly available across multiple AZs.
* **Data Plane:** Consists of the EC2 instances that run your containers. In this example, we use **Managed Node Groups**, where AWS handles the node lifecycle (AMI updates, patching).

## 2. Security and IAM Roles

EKS requires several specific IAM roles:

1.  **EKS Cluster IAM Role:** Used by the **Control Plane** to call AWS APIs (e.g., creating Elastic Load Balancers, managing ENIs). This role must have a Trust Policy allowing `eks.amazonaws.com` to assume it.
2.  **EKS Node IAM Role:** Used by the **Worker Nodes** to register themselves with the cluster, pull container images, and write logs. This role must have a Trust Policy allowing `ec2.amazonaws.com` to assume it.
3.  **IRSA (IAM Roles for Service Accounts):** The modern, secure way to grant AWS permissions to individual Kubernetes Pods, rather than granting broad access to the entire worker node group.

## 3. Networking Essentials (VPC CNI)

* **VPC CNI Plugin:** EKS requires the Amazon VPC CNI (Container Network Interface) to assign a private VPC IP address to every Kubernetes Pod. This allows pods to communicate with other AWS services (like RDS or S3) using standard VPC routing and Security Groups.
* **Subnets:** EKS requires three types of subnets, though we only use private subnets for the nodes themselves:
    * **Private Subnets:** Where the worker nodes (EC2 instances) are deployed. They access the internet via a NAT Gateway.
    * **Public Subnets:** Where AWS often deploys resources like Load Balancers to expose services to the internet.
