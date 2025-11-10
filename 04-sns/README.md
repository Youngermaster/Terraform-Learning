# SNS (Simple Notification Service) Example

This example demonstrates SNS pub/sub pattern with SQS queue subscriptions and message filtering.

## What You'll Learn

- Creating SNS topics
- Subscribing SQS queues to SNS topics
- Using filter policies to route messages
- Fan-out pattern (one message to multiple subscribers)

## Resources Created

- **user-events-topic**: SNS topic for publishing user events
- **email-notification-queue**: Receives user registration and password reset events
- **sms-notification-queue**: Receives urgent alerts
- Two topic subscriptions with different filter policies

## Usage

```bash
# Initialize and apply
terraform init
terraform apply

# List SNS topics
awslocal sns list-topics

# Publish a user registration event (goes to email queue)
awslocal sns publish \
  --topic-arn arn:aws:sns:us-east-1:000000000000:user-events-topic \
  --message "User john@example.com registered" \
  --message-attributes '{"event_type":{"DataType":"String","StringValue":"user_registered"}}'

# Publish an urgent alert (goes to SMS queue)
awslocal sns publish \
  --topic-arn arn:aws:sns:us-east-1:000000000000:user-events-topic \
  --message "System critical alert" \
  --message-attributes '{"event_type":{"DataType":"String","StringValue":"urgent_alert"}}'

# Check email queue for messages
awslocal sqs receive-message \
  --queue-url http://localhost:4566/000000000000/email-notification-queue

# Check SMS queue for messages
awslocal sqs receive-message \
  --queue-url http://localhost:4566/000000000000/sms-notification-queue

# List subscriptions
awslocal sns list-subscriptions

# Cleanup
terraform destroy
```

## Key Concepts

- **Pub/Sub Pattern**: Publishers send messages without knowing subscribers
- **Fan-out**: One SNS message can trigger multiple SQS queues
- **Filter Policy**: Routes messages based on attributes (like event_type)
- **Message Attributes**: Metadata used for filtering and routing
- **Decoupling**: Publishers and subscribers don't need to know about each other
