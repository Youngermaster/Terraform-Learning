terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  access_key = "test"
  secret_key = "test"
  s3_use_path_style =  true # Modern equivalent of force_path_style
  skip_credentials_validation = true
  skip_requesting_account_id = true
  endpoints {
    s3 = "http://localhost:4566"
  }
}

# S3 bucket in LocalStack
resource "aws_s3_bucket" "bucket_a" {
  bucket = "demo-bucket-a"
}

resource "aws_s3_bucket" "bucket_b" {
  bucket = "demo-bucket-b"
}

output "buckets" {
  value = [
    aws_s3_bucket.bucket_a.bucket,
    aws_s3_bucket.bucket_b.bucket
  ]
}