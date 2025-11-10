# Lambda Example

This example creates an AWS Lambda function with a simple Python handler.

## What You'll Learn

- Creating Lambda functions with Terraform
- Packaging Python code for Lambda
- Setting up IAM roles for Lambda execution
- Configuring environment variables
- Invoking Lambda functions

## Resources Created

- **demo-function**: A Python Lambda function that processes events
- **lambda_role**: IAM role with permissions for Lambda execution

## Usage

```bash
# Initialize and apply
terraform init
terraform apply

# List Lambda functions
awslocal lambda list-functions

# Invoke the function with a test event
awslocal lambda invoke \
  --function-name demo-function \
  --payload '{"name": "Alice", "action": "greeting"}' \
  output.txt

# View the response
cat output.txt

# Try different actions
awslocal lambda invoke \
  --function-name demo-function \
  --payload '{"name": "Bob", "action": "farewell"}' \
  output.txt

# Get function configuration
awslocal lambda get-function --function-name demo-function

# View logs (if available in LocalStack)
awslocal logs tail /aws/lambda/demo-function --follow

# Cleanup
terraform destroy
rm -f output.txt lambda_function.zip
```

## Key Concepts

- **Handler**: Entry point for Lambda execution (filename.function_name)
- **Runtime**: Execution environment (Python 3.11 in this example)
- **IAM Role**: Permissions needed for Lambda to execute and access AWS services
- **Environment Variables**: Configuration passed to the function
- **Source Code Hash**: Used to detect changes and trigger updates
