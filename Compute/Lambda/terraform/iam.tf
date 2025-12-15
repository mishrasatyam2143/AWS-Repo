# IAM Role Trust Policy: Allows the Lambda Service to assume this role

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# 1. Lambda Execution Role
resource "aws_iam_role" "lambda_exec" {
  name               = "lambda-greeting-exec-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# 2. AWS Managed Policy for CloudWatch Logging
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_exec.name
  # This policy grants permissions for basic logging to CloudWatch
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
