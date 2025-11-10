terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_requesting_account_id  = true

  endpoints {
    lambda = "http://localhost:4566"
    iam    = "http://localhost:4566"
  }
}

# IAM role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "demo_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Package Lambda function
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_function.py"
  output_path = "${path.module}/lambda_function.zip"
}

# Lambda function
resource "aws_lambda_function" "demo_function" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "demo-function"
  role            = aws_iam_role.lambda_role.arn
  handler         = "lambda_function.handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime         = "python3.11"
  timeout         = 30

  environment {
    variables = {
      ENVIRONMENT = "dev"
      LOG_LEVEL   = "INFO"
    }
  }

  tags = {
    Environment = "dev"
    Purpose     = "learning"
  }
}

output "function_name" {
  value       = aws_lambda_function.demo_function.function_name
  description = "Name of the Lambda function"
}

output "function_arn" {
  value       = aws_lambda_function.demo_function.arn
  description = "ARN of the Lambda function"
}
