#  Compute: AWS Lambda Serverless Function

This directory contains a complete, deployable example of a serverless Python Lambda function, defining all infrastructure components using **Terraform**.

##  Repository Structure

* `lambda-intro.md`: Conceptual deep dive into AWS Lambda concepts, execution environments, and best practices.
* `sample-function.py`: The Python source code for the greeting function.
* `scripts/`: Contains the shell script to package the code into a `.zip` file.
* `terraform/`: Contains all Infrastructure-as-Code files (`.tf`) for function deployment and IAM configuration.

##  Deployment Instructions (Terraform)

1.  **Package the Code:**
    Run the deployment script to create the `function.zip` file, which Terraform needs:
    ```bash
    ./scripts/create_package.sh
    ```

2.  **Deploy Infrastructure:**
    Navigate to the Terraform directory and deploy:
    ```bash
    cd terraform
    terraform init
    terraform apply
    ```

3.  **Testing the Function (via AWS CLI):**
    Use the AWS CLI to invoke the deployed function:
    ```bash
    aws lambda invoke \
      --function-name greeting-lambda-function \
      --payload '{"name": "Terraform User"}' \
      response.json
    
    cat response.json  # Expected output: {"statusCode": 200, "body": "Hello, Terraform User!"}
    ```
