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
    sqs = "http://localhost:4566"
  }
}

# Standard SQS queue for order processing
resource "aws_sqs_queue" "orders_queue" {
  name                      = "orders-queue"
  delay_seconds             = 0
  max_message_size          = 262144
  message_retention_seconds = 345600  # 4 days
  receive_wait_time_seconds = 10      # Long polling

  tags = {
    Environment = "dev"
    Purpose     = "order-processing"
  }
}

# Dead Letter Queue for failed messages
resource "aws_sqs_queue" "orders_dlq" {
  name = "orders-dlq"

  tags = {
    Environment = "dev"
    Purpose     = "dead-letter"
  }
}

# FIFO queue for strict ordering
resource "aws_sqs_queue" "notifications_fifo" {
  name                        = "notifications.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"

  tags = {
    Environment = "dev"
    Purpose     = "notifications"
  }
}

output "orders_queue_url" {
  value       = aws_sqs_queue.orders_queue.url
  description = "URL of the orders queue"
}

output "orders_dlq_url" {
  value       = aws_sqs_queue.orders_dlq.url
  description = "URL of the dead letter queue"
}

output "notifications_fifo_url" {
  value       = aws_sqs_queue.notifications_fifo.url
  description = "URL of the FIFO notifications queue"
}
