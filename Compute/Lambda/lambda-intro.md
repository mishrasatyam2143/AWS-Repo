# Lambda Intro

Topics covered:
- What is AWS Lambda
- Use cases for serverless (small jobs, webhooks, scheduled tasks)
- Supported runtimes (Python, Node.js, etc)
- IAM role basics for Lambda
- Deployment options (console, AWS CLI, SAM, Terraform)

Quick example
- Create role with minimal permissions for Lambda execution and basic CloudWatch logs.
- Zip function and deploy or use SAM for local testing.

Security note: never embed secrets in code. Use Secrets Manager or environment variables with encryption.
