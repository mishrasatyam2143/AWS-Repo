#!/bin/bash
# Zips the sample-function.py file into a deployment package
LAMBDA_DIR="$(dirname "$0")/.."

# Create the zip file at the root of the Lambda directory
zip -j "$LAMBDA_DIR/function.zip" "$LAMBDA_DIR/sample-function.py" 

echo "Deployment package 'function.zip' created successfully."
