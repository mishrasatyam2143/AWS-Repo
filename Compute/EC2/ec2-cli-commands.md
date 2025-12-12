# EC2 CLI Commands (Cheat Sheet)

## Prerequisites

Before using any EC2 CLI command, configure AWS CLI:

```bash
aws configure

```

- You must set:

- AWS Access Key ID

- AWS Secret Access Key

- Default Region Name

- Default Output Format (json, yaml, or table)

---

#  1. EC2 Instance Information Commands

List all instances (table format)

```bash
aws ec2 describe-instances --output table
```

Shows all instances with all attributes.

---

List specific fields (clean output)

```bash
aws ec2 describe-instances \
  --query 'Reservations[].Instances[].{ID:InstanceId,State:State.Name,Type:InstanceType,PublicIP:PublicIpAddress,Name:Tags[?Key==`Name`].Value|[0]}' \
  --output table
```
---

List only instance IDs

```bash
aws ec2 describe-instances --query 'Reservations[].Instances[].InstanceId' --output text
```
---

Get details of a single instance

```bash
aws ec2 describe-instances --instance-ids i-1234567890abcdef0
```
---

#  2. Launching EC2 Instances
Launch a basic EC2 instance

```bash
aws ec2 run-instances \
  --image-id ami-0123456789abcdef0 \
  --instance-type t3.micro \
  --key-name my-key \
  --security-group-ids sg-01234567 \
  --subnet-id subnet-01234567 \
  --count 1
```

Important Parameters

1. --image-id → AMI (OS image)

2. --instance-type → CPU/RAM spec

3. --key-name → SSH key pair

4. --security-group-ids → firewall rules

5. --subnet-id → network placement

---

#  3. Managing EC2 Instance Lifecycle

Start an instance

```bash
aws ec2 start-instances --instance-ids i-1234567890abcdef0
```

Stop an instance

```bash
aws ec2 stop-instances --instance-ids i-1234567890abcdef0
```

Reboot an instance

```bash
aws ec2 reboot-instances --instance-ids i-1234567890abcdef0
```

Terminate an instance

```bash
aws ec2 terminate-instances --instance-ids i-1234567890abcdef0
```

#  4. Working With Security Groups

List security groups

```bash
aws ec2 describe-security-groups --output table
```

Create a security group

```bash
aws ec2 create-security-group \
  --group-name web-sg \
  --description "Allow web traffic" \
  --vpc-id vpc-12345678
```

Add inbound SSH rule

```bash
aws ec2 authorize-security-group-ingress \
  --group-id sg-12345678 \
  --protocol tcp \
  --port 22 \
  --cidr 203.0.113.5/32
```
---

#  5. Working With Key Pairs

List key pairs

```bash
aws ec2 describe-key-pairs
```

Create a key pair and save it locally

```bash
aws ec2 create-key-pair --key-name my-key --query 'KeyMaterial' --output text > my-key.pem
chmod 400 my-key.pem
```

---

#  6. EBS Volume Commands

Create a volume

```bash
aws ec2 create-volume \
  --availability-zone ap-south-1a \
  --size 20 \
  --volume-type gp3
```

List all volumes

```bash
aws ec2 describe-volumes --output table
```

Attach volume

```bash
aws ec2 attach-volume \
  --volume-id vol-1234567890abcdef0 \
  --instance-id i-1234567890abcdef0 \
  --device /dev/xvdf
```

Detach volume

```bash
aws ec2 detach-volume --volume-id vol-1234567890abcdef0
```
---

#  7. Elastic IP Commands

Allocate an Elastic IP

```bash
aws ec2 allocate-address
```

Associate EIP with instance

```bash
aws ec2 associate-address \
  --instance-id i-1234567890abcdef0 \
  --allocation-id eipalloc-12345678
```
---

#  8. Tagging Resources

Add tags to an instance

```bash
aws ec2 create-tags \
  --resources i-1234567890abcdef0 \
  --tags Key=Name,Value=MyServer
```

View tags

```bash
aws ec2 describe-tags --filters "Name=resource-id,Values=i-1234567890abcdef0"
```

---

# 9. EC2 Instance Metadata (Run inside EC2)

Get instance ID

```bash
curl http://169.254.169.254/latest/meta-data/instance-id
```

Get public IP

```bash
curl http://169.254.169.254/latest/meta-data/public-ipv4
```

---

# 10. Useful Filters and Query Helpers

Get running instances only

```bash
aws ec2 describe-instances \
  --filters Name=instance-state-name,Values=running \
  --output table
```

Filter instances by Name tag

```bash
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=WebServer"
```
---

# Best Practices

- Use IAM roles instead of storing keys

- Prefer SSM Session Manager over SSH

- Restrict SSH access to your IP

- Always tag resources

- Use Auto Scaling Groups for production

- Enable EBS encryption by default

- Use filters + queries (--query) for cleaner results
