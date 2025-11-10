# SQS (Simple Queue Service) Example

This example creates multiple SQS queues demonstrating different queue types and patterns.

## What You'll Learn

- Creating standard SQS queues
- Setting up Dead Letter Queues (DLQ) for error handling
- Creating FIFO queues for strict message ordering
- Configuring message retention and polling behavior

## Resources Created

- **orders-queue**: Standard queue with long polling
- **orders-dlq**: Dead Letter Queue for failed messages
- **notifications.fifo**: FIFO queue with content-based deduplication

## Usage

```bash
# Initialize and apply
terraform init
terraform apply

# List all queues
awslocal sqs list-queues

# Send a message to standard queue
awslocal sqs send-message \
  --queue-url http://localhost:4566/000000000000/orders-queue \
  --message-body "Order #12345"

# Send message to FIFO queue (requires MessageGroupId)
awslocal sqs send-message \
  --queue-url http://localhost:4566/000000000000/notifications.fifo \
  --message-body "User notification" \
  --message-group-id "user-group-1"

# Receive messages
awslocal sqs receive-message \
  --queue-url http://localhost:4566/000000000000/orders-queue

# Get queue attributes
awslocal sqs get-queue-attributes \
  --queue-url http://localhost:4566/000000000000/orders-queue \
  --attribute-names All

# Cleanup
terraform destroy
```

## Key Concepts

- **Standard Queue**: At-least-once delivery, best-effort ordering
- **FIFO Queue**: Exactly-once processing, strict ordering within message groups
- **Long Polling**: Reduces empty responses and costs by waiting for messages
- **Dead Letter Queue**: Captures messages that fail processing repeatedly
