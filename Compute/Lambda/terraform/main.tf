# Data source to automatically zip the Python file and compute a hash for updates

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/../sample-function.py"
  output_path = "${path.module}/../function.zip" # Output the zip file
}

# 1. The main Lambda resource
resource "aws_lambda_function" "sample_function" {
  function_name    = "greeting-lambda-function"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "sample-function.lambda_handler" # filename.function_name
  runtime          = "python3.11"
  timeout          = 10
  
  # Deploy the code package and ensure updates when code changes
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
}

# 2. (Optional but recommended) CloudWatch Log Group
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.sample_function.function_name}"
  retention_in_days = 7
}

output "lambda_function_arn" {
  description = "The ARN of the deployed Lambda function."
  value       = aws_lambda_function.sample_function.arn
}
