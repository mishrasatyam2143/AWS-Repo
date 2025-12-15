# AWS Lambda: Python Greeting Function Deployment

This directory contains a complete, deployable example of a Python Lambda function managed by Terraform.

## `:x
 Deployment Steps

1.  **Run Prerequisites:**
    Ensure Terraform and the AWS CLI are installed.

2.  **Package the Code:**
    Execute the packaging script to create the deployment ZIP file:
    ```bash
    ./scripts/create_package.sh
    ```

3.  **Deploy Infrastructure:**
    Navigate to the Terraform directory and deploy:
    ```bash
    cd terraform
    terraform init
    terraform plan
    terraform apply
    ```

4.  **Test the Function:**
    Use the AWS CLI to invoke the deployed function with a payload:
    ```bash
    aws lambda invoke \
      --function-name greeting-lambda-function \
      --payload '{"name": "Terraform"}' \
      response.json
    
    cat response.json
    ```
    (The `response.json` file will contain the output: `"Hello, Terraform!"`)

---


