# EC2 Basics

Amazon EC2 (Elastic Compute Cloud) is a core AWS compute service that provides **resizable virtual servers** in the cloud. You can launch, configure, scale, and terminate virtual machines based on your workload needs.

---

## What is EC2?

EC2 is a cloud-based virtual machine service that provides:

- On-demand compute capacity  
- Customizable CPU, RAM, storage, and networking  
- Flexible OS choice (Linux, Windows, custom AMIs)  
- Pay-as-you-go pricing  
- Integration with VPC, IAM, CloudWatch, EBS, and many other AWS services  

### EC2 Use Cases

- Hosting web applications  
- Running backend APIs  
- Databases and caching layers  
- CI/CD runners  
- Batch processing  
- Container hosting (ECS, EKS worker nodes)  

---

## EC2 Instance Types and Families

EC2 instances are grouped into families based on optimization needs.

### Common Families

**General purpose (t, m)**  
Balanced compute, memory, network.  
Examples: `t3.micro`, `m5.large`

**Compute optimized (c)**  
High CPU performance.  
Example: `c5.large`

**Memory optimized (r, x)**  
High RAM for databases, analytics workloads.  
Example: `r5.xlarge`

**Storage optimized (i, d)**  
High disk throughput via NVMe SSDs.  
Example: `i3.large`

**Accelerated computing (p, g)**  
GPU-based for ML, graphics, HPC.  
Examples: `p3.2xlarge`, `g4dn.xlarge`

### Instance Sizes

`micro → small → medium → large → xlarge → 2xlarge → …`  
Each size increase provides more CPU, RAM, and network performance.

---

## Amazon Machine Image (AMI)

An AMI is the **template** used to launch EC2 instances.

An AMI contains:

- Operating system  
- Pre-installed software  
- Bootstrapped configuration  
- Optional customizations (e.g., Packer-built AMIs)

### AMI Examples

- Amazon Linux 2  
- Ubuntu  
- Windows Server  
- Custom AMIs  

**Note:** AMIs are region-specific.

---

## Key Pair (SSH Key)

A key pair is used to authenticate into EC2.

- **Linux:** SSH using `.pem` private key  
- **Windows:** decrypt admin password using the key  

AWS does **not** allow re-download of the private key. If lost, you must create a new one.

---

## Security Groups (SG)

Security Groups act as **stateful virtual firewalls**.

### Key Features

- Control inbound and outbound traffic  
- Stateful: return traffic is automatically allowed  
- Attached at the instance level  

### Example Rule

Type: SSH
Port: 22
Source: 203.0.113.5/32

yaml
Copy code

---

## VPC and Subnets

Instances launch inside a **Virtual Private Cloud (VPC)**.

### Subnets

- **Public subnet** → route to Internet Gateway  
- **Private subnet** → no direct internet (uses NAT Gateway)  

### Best Practices

- Public subnet → web servers  
- Private subnet → databases / internal services  

---

## Elastic IP (EIP)

A static public IPv4 address you can attach to an instance.

### Use cases:

- Fixed IP for DNS  
- When instance restarts  
- Production apps needing stable endpoints  

**Note:** EIP costs money when *not attached*.

---

## EBS Volumes (Elastic Block Store)

Network-attached persistent storage for EC2.

### Volume Types

- **gp3** – general purpose SSD  
- **io2** – provisioned IOPS SSD  
- **st1** – throughput HDD  
- **sc1** – cold HDD  

### Properties

- Persist beyond instance termination (optional)  
- Can be resized  
- Support snapshots  

---

## Placement Groups

Control how AWS places EC2 instances physically.

### Types

- **Cluster** – low latency, high bandwidth  
- **Spread** – maximum fault tolerance  
- **Partition** – big data workloads (Hadoop, Spark)  

---

## EC2 Instance Lifecycle

### States

- pending  
- running  
- stopping  
- stopped  
- terminated  

### Billing Rules

- Charged when instance is **running**  
- EBS volumes charge even if the instance is stopped  
- EIP charges when unused  

---

## Launching an EC2 Instance (Simplified)

1. Choose AMI  
2. Select instance type  
3. Choose VPC + subnet  
4. Configure EBS storage  
5. Add tags  
6. Set security groups  
7. Select or create key pair  
8. Launch  

---

## Useful EC2 CLI Commands

### List instances
```bash
aws ec2 describe-instances --output table
Stop instance

aws ec2 stop-instances --instance-ids i-xxxxxxxxxxxxx
Start instance

aws ec2 start-instances --instance-ids i-xxxxxxxxxxxxx
Terminate instance

aws ec2 terminate-instances --instance-ids i-xxxxxxxxxxxxx
Create an EBS volume

aws ec2 create-volume --size 8 --availability-zone ap-south-1a --volume-type gp3

---

Best Practices
Use IAM roles instead of storing AWS keys

Restrict SSH to your IP

Prefer SSM Session Manager over SSH

Tag all instances

Use Auto Scaling Groups for production

Enable EBS encryption by default

---
