# EC2 CLI Commands (cheat sheet)

Prerequisites

Before using any EC2 CLI command, configure AWS CLI:

aws configure


You must set:

AWS Access Key ID

AWS Secret Access Key

Default Region Name

Default Output Format (json, yaml, or table)

1. EC2 Instance Information Commands
List all instances (table format)
aws ec2 describe-instances --output table


Shows all instances with all attributes.

List specific fields (clean output)
aws ec2 describe-instances \
    --query 'Reservations[].Instances[].{ID:InstanceId,State:State.Name,Type:InstanceType,PublicIP:PublicIpAddress,Name:Tags[?Key==`Name`].Value|[0]}' \
    --output table

List only instance IDs
aws ec2 describe-instances --query 'Reservations[].Instances[].InstanceId' --output text

Get details of a single instance
aws ec2 describe-instances --instance-ids i-1234567890abcdef0

2. Launching EC2 Instances
Launch a basic EC2 instance
aws ec2 run-instances \
  --image-id ami-0123456789abcdef0 \
  --instance-type t3.micro \
  --key-name my-key \
  --security-group-ids sg-01234567 \
  --subnet-id subnet-01234567 \
  --count 1

Important parameters

--image-id → AMI (OS image)

--instance-type → CPU/RAM spec

--key-name → SSH key pair name

--security-group-ids → firewall rules

--subnet-id → network placement

3. Managing EC2 Instance Lifecycle
Start instance
aws ec2 start-instances --instance-ids i-1234567890abcdef0

Stop instance
aws ec2 stop-instances --instance-ids i-1234567890abcdef0

Reboot instance
aws ec2 reboot-instances --instance-ids i-1234567890abcdef0

Terminate instance
aws ec2 terminate-instances --instance-ids i-1234567890abcdef0

4. Working with Security Groups
List security groups
aws ec2 describe-security-groups --output table

Create a new security group
aws ec2 create-security-group \
  --group-name web-sg \
  --description "Allow web traffic" \
  --vpc-id vpc-12345678

Add an inbound SSH rule
aws ec2 authorize-security-group-ingress \
  --group-id sg-12345678 \
  --protocol tcp \
  --port 22 \
  --cidr 203.0.113.5/32

5. Working with Key Pairs
List key pairs
aws ec2 describe-key-pairs

Create a key pair and save to file
aws ec2 create-key-pair --key-name my-key --query 'KeyMaterial' --output text > my-key.pem
chmod 400 my-key.pem

6. EBS Volume Commands
Create EBS volume
aws ec2 create-volume \
  --availability-zone ap-south-1a \
  --size 20 \
  --volume-type gp3

List all volumes
aws ec2 describe-volumes --output table

Attach volume to instance
aws ec2 attach-volume \
  --volume-id vol-1234567890abcdef0 \
  --instance-id i-1234567890abcdef0 \
  --device /dev/xvdf

Detach volume
aws ec2 detach-volume --volume-id vol-1234567890abcdef0

7. Elastic IP Commands
Allocate an Elastic IP
aws ec2 allocate-address

Associate EIP with instance
aws ec2 associate-address \
  --instance-id i-1234567890abcdef0 \
  --allocation-id eipalloc-12345678

8. Tagging Resources
Add tags to an instance
aws ec2 create-tags \
  --resources i-1234567890abcdef0 \
  --tags Key=Name,Value=MyServer

View tags
aws ec2 describe-tags --filters "Name=resource-id,Values=i-1234567890abcdef0"

9. Instance Metadata (From Inside the EC2 Instance)
Get instance ID
curl http://169.254.169.254/latest/meta-data/instance-id

Get public IP
curl http://169.254.169.254/latest/meta-data/public-ipv4

10. Useful Filters and Helpers
Filter running instances only
aws ec2 describe-instances \
  --filters Name=instance-state-name,Values=running \
  --output table

Filter by Name tag
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=WebServer"

Best Practices

Use IAM roles instead of storing credentials

Prefer SSM Session Manager over SSH

Restrict SSH access to your IP

Always tag resources

Use Auto Scaling Groups for production

Use EBS encryption by default

Use Filters + Queries (--query) for cleaner results
