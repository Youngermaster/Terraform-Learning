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
    sns = "http://localhost:4566"
    sqs = "http://localhost:4566"
  }
}

# SNS topic for user events
resource "aws_sns_topic" "user_events" {
  name = "user-events-topic"

  tags = {
    Environment = "dev"
    Purpose     = "event-notification"
  }
}

# SQS queue to receive SNS messages
resource "aws_sqs_queue" "email_queue" {
  name = "email-notification-queue"

  tags = {
    Environment = "dev"
    Purpose     = "email-processing"
  }
}

# Another queue for SMS notifications
resource "aws_sqs_queue" "sms_queue" {
  name = "sms-notification-queue"

  tags = {
    Environment = "dev"
    Purpose     = "sms-processing"
  }
}

# Subscribe email queue to SNS topic
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.user_events.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.email_queue.arn

  filter_policy = jsonencode({
    event_type = ["user_registered", "password_reset"]
  })
}

# Subscribe SMS queue to SNS topic
resource "aws_sns_topic_subscription" "sms_subscription" {
  topic_arn = aws_sns_topic.user_events.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.sms_queue.arn

  filter_policy = jsonencode({
    event_type = ["urgent_alert"]
  })
}

output "topic_arn" {
  value       = aws_sns_topic.user_events.arn
  description = "ARN of the SNS topic"
}

output "email_queue_url" {
  value       = aws_sqs_queue.email_queue.url
  description = "URL of the email notification queue"
}

output "sms_queue_url" {
  value       = aws_sqs_queue.sms_queue.url
  description = "URL of the SMS notification queue"
}
