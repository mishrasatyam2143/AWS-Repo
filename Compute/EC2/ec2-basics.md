EC2 Basics

Amazon EC2 (Elastic Compute Cloud) is a core AWS compute service that provides resizable virtual servers in the cloud. You can launch, configure, scale, and terminate virtual machines based on your workload needs.

What is EC2?

EC2 is a cloud-based virtual machine service that provides:

On-demand compute capacity

Customizable CPU, RAM, storage, and networking

Flexible OS choice (Linux, Windows, custom AMIs)

Pay-as-you-go pricing

Integration with VPC, IAM, CloudWatch, EBS and many other AWS services

Common Use Cases

Hosting web applications

Running backend APIs

Databases and caching layers

CI/CD runners

Batch processing

Container hosting (ECS, EKS worker nodes)

EC2 Instance Types and Families

EC2 instances are grouped into families based on optimization needs.

Common Families

General purpose (t, m)
Balanced compute, memory, network.
Examples: t3.micro, m5.large

Compute optimized (c)
High CPU performance.
Example: c5.large

Memory optimized (r, x)
High RAM for databases, analytics workloads.
Example: r5.xlarge

Storage optimized (i, d)
High disk throughput using NVMe SSDs.
Example: i3.large

Accelerated computing (p, g)
GPU-based for ML, graphics, and HPC.
Examples: p3.2xlarge, g4dn.xlarge

Instance Sizes

Instance sizes define available resources:

micro → small → medium → large → xlarge → 2xlarge → ...

Each step increases:

vCPU

Memory

Network performance

What is an AMI (Amazon Machine Image)?

An AMI is the template used to launch EC2 instances. It contains:

Operating System

Pre-installed software

Configuration settings

Optional customizations (via tools like Packer)

Common AMI Types

Amazon Linux 2

Ubuntu

Windows Server

Custom AMIs (snapshots, golden images)

Important: AMIs are region-specific.

Key Pair (SSH Key)

A key pair is used to authenticate into an EC2 instance.

Linux: SSH using the private key (.pem)

Windows: Decrypt the admin password using the key

If you lose the .pem file, AWS does not let you re-download it.

Security Group (SG)

A Security Group is a stateful virtual firewall that controls instance traffic.

Key Points

Controls inbound/outbound rules

Stateful (reply traffic automatically allowed)

Attached at instance level

Default outbound is allow-all

Example: Allow SSH only from your IP
Type: SSH
Port: 22
Source: 203.0.113.5/32

Subnet and VPC

Instances run inside a Virtual Private Cloud (VPC).

Subnets

Public subnet: Has route to an Internet Gateway

Private subnet: No direct internet access; uses NAT Gateway if needed

Best Practices

Web servers in public subnet

Databases in private subnet

Elastic IP (EIP)

A static public IPv4 address owned by your AWS account.

When to use:

When your instance restarts and needs a fixed IP

When hosting production apps

When dealing with DNS records pointing to a server

Note: EIP incurs cost if not attached to a running instance.

EBS Volumes (Elastic Block Store)

EBS provides persistent block storage for EC2 instances.

Volume Types

gp3: General purpose SSD

io2: High IOPS SSD

st1: Throughput optimized HDD

sc1: Cold HDD

Use Cases

Root OS volume

Additional storage

Database storage

Snapshots for backup or AMI creation

Properties

Persistent beyond EC2 termination (unless delete-on-termination=true)

Can be resized

Supports snapshots

Placement Groups

Placement groups control how EC2 instances are placed on AWS hardware.

Types

Cluster: Low latency, high bandwidth (same rack)

Spread: Instances on different hardware (fault tolerance)

Partition: Used by Hadoop, Spark, large distributed systems

EC2 Instance Lifecycle
States

pending

running

stopping

stopped

terminated

Billing Notes

You pay when an instance is running

EBS volumes continue billing even if instance is stopped

EIP bills when unused

Launching an EC2 Instance (Simplified Steps)

Choose an AMI

Select instance type (e.g., t3.micro)

Choose VPC + subnet

Configure storage (EBS)

Add tags

Configure security group rules

Create/select key pair

Launch instance

Useful EC2 CLI Commands
List instances
aws ec2 describe-instances --output table

Stop instance
aws ec2 stop-instances --instance-ids i-xxxxxxxxxxxxx

Start instance
aws ec2 start-instances --instance-ids i-xxxxxxxxxxxxx

Terminate instance
aws ec2 terminate-instances --instance-ids i-xxxxxxxxxxxxx

Create an EBS volume
aws ec2 create-volume --size 8 --availability-zone ap-south-1a --volume-type gp3

Notes / Best Practices

Use IAM roles instead of storing AWS keys on the server

Restrict SSH to your own IP only

Prefer SSM Session Manager over SSH

Always tag resources for tracking

Use Auto Scaling Groups for production workloads

Enable EBS encryption by default
