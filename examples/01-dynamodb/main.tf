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
    dynamodb = "http://localhost:4566"
  }
}

# DynamoDB table for storing user data
resource "aws_dynamodb_table" "users" {
  name           = "users-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "user_id"
  range_key      = "timestamp"

  attribute {
    name = "user_id"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "N"
  }

  attribute {
    name = "email"
    type = "S"
  }

  # Global secondary index for querying by email
  global_secondary_index {
    name            = "email-index"
    hash_key        = "email"
    projection_type = "ALL"
  }

  tags = {
    Environment = "dev"
    Purpose     = "learning"
  }
}

output "table_name" {
  value       = aws_dynamodb_table.users.name
  description = "The name of the DynamoDB table"
}

output "table_arn" {
  value       = aws_dynamodb_table.users.arn
  description = "The ARN of the DynamoDB table"
}
