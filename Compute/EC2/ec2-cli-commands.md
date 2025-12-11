# EC2 CLI Commands (cheat sheet)

Prerequisite:
- aws configure (set region, access key id, secret access key)

List instances:
aws ec2 describe-instances --query 'Reservations[].Instances[].[InstanceId,InstanceType,State.Name,PublicIpAddress,Tags]' --output table

Launch instance:
aws ec2 run-instances \
  --image-id ami-0123456789abcdef0 \
  --instance-type t3.micro \
  --key-name my-key \
  --security-group-ids sg-01234567 \
  --subnet-id subnet-01234567 \
  --count 1

Stop instance:
aws ec2 stop-instances --instance-ids i-0123456789abcdef0

Start instance:
aws ec2 start-instances --instance-ids i-0123456789abcdef0

Terminate instance:
aws ec2 terminate-instances --instance-ids i-0123456789abcdef0

Create EBS volume:
aws ec2 create-volume --size 8 --availability-zone ap-south-1a --volume-type gp3

Attach volume:
aws ec2 attach-volume --volume-id vol-0123456789abcdef0 --instance-id i-0abcdef123456 --device /dev/sdf
