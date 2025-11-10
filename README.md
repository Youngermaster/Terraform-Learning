# Terraform Learning

This is a simple repo I did to learn Terraform with LocalStack by myself

# Setup

You can check the `setup.sh` script for installing Terraform and LocalStack CLI.
That script is designed for macOS with Homebrew.

## Prerequisites

Make sure LocalStack is running:
```bash
localstack start
```

## Examples Overview

### 01-dynamodb
**Learn:** DynamoDB tables, primary keys, GSI (Global Secondary Index)

Creates a users table with email-based secondary index for alternative query patterns.

### 02-sqs
**Learn:** Message queues, FIFO vs standard queues, dead letter queues

Creates multiple SQS queues demonstrating different queue types and patterns.

### 03-lambda
**Learn:** Serverless functions, IAM roles, function deployment

Creates a Python Lambda function that processes events with different actions.

### 04-sns
**Learn:** Pub/sub messaging, fan-out pattern, message filtering

Creates SNS topic with SQS subscriptions and demonstrates message routing with filter policies.

### 05-api-gateway
**Learn:** REST APIs, Lambda integration, API deployment

Creates a REST API with multiple endpoints backed by Lambda functions.

## How to Use

Each example is independent. Navigate to any example and run:

```bash
cd 01-dynamodb
terraform init
terraform apply
```

Follow the instructions in each example's README.md for testing and cleanup.

## Learning Path

The examples are ordered by complexity:

1. Start with **DynamoDB** (simplest - just resource creation)
2. Move to **SQS** (introduces multiple resources and relationships)
3. Try **Lambda** (adds code deployment and packaging)
4. Explore **SNS** (demonstrates resource integration)
5. Build **API Gateway** (most complex - multiple services working together)

## Tips

- Always run `terraform destroy` when done to clean up resources
- Use `awslocal` commands to interact with LocalStack services
- Check the README.md in each example for specific testing commands
- Each example includes outputs that show important resource information
