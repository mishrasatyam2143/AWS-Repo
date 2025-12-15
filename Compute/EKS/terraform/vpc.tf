# 1. VPC (Required for EKS)
resource "aws_vpc" "eks_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "eks-demo-vpc"
  }
}

# 2. Public Subnets (For Load Balancers and EKS Endpoint)
resource "aws_subnet" "public" {
  count             = 2
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.0.${count.index + 1}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]
  
  tags = {
    Name                                      = "eks-public-subnet-${count.index}"
    "kubernetes.io/role/elb"                  = "1" # Required tag for Load Balancers
  }
}

# 3. Private Subnets (For Worker Nodes)
resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.0.${count.index + 3}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name                                      = "eks-private-subnet-${count.index}"
    "kubernetes.io/role/internal-elb"         = "1" # Required tag for internal Load Balancers
    "kubernetes.io/cluster/eks-demo-cluster"  = "owned" # Required for EKS auto-discovery
  }
}

# 4. NAT Gateway and Internet Gateway (Connectivity)
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.eks_vpc.id
  tags   = { Name = "eks-igw" }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public[0].id # Place NAT in a public subnet
  tags          = { Name = "eks-nat-gw" }
}

# 5. Route Tables (Private Subnet Routing)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.eks_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = { Name = "eks-private-rt" }
}

resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
