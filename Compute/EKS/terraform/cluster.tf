# 1. IAM Role for EKS Control Plane
resource "aws_iam_role" "eks_cluster" {
  name = "eks-cluster-role"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

# Attach standard EKS cluster policy
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

# 2. EKS Cluster Definition
resource "aws_eks_cluster" "main" {
  name     = "eks-demo-cluster"
  role_arn = aws_iam_role.eks_cluster.arn
  version  = "1.28" # Specify your desired Kubernetes version

  vpc_config {
    subnet_ids = concat(aws_subnet.public[*].id, aws_subnet.private[*].id)
    security_group_ids = []
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
  ]
}
