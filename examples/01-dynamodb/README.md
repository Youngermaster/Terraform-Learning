# DynamoDB Example

This example creates a DynamoDB table with a global secondary index.

## What You'll Learn

- Creating a DynamoDB table with partition and sort keys
- Defining attributes and their types
- Setting up a Global Secondary Index (GSI) for alternative query patterns
- Using PAY_PER_REQUEST billing mode

## Resources Created

- **users-table**: A DynamoDB table with:
  - Primary key: `user_id` (string)
  - Sort key: `timestamp` (number)
  - GSI on `email` for email-based queries

## Usage

```bash
# Initialize and apply
terraform init
terraform apply

# Test with awslocal
awslocal dynamodb list-tables
awslocal dynamodb describe-table --table-name users-table

# Insert a test item
awslocal dynamodb put-item \
  --table-name users-table \
  --item '{"user_id": {"S": "user123"}, "timestamp": {"N": "1234567890"}, "email": {"S": "test@example.com"}, "name": {"S": "John Doe"}}'

# Query by user_id
awslocal dynamodb query \
  --table-name users-table \
  --key-condition-expression "user_id = :uid" \
  --expression-attribute-values '{":uid": {"S": "user123"}}'

# Cleanup
terraform destroy
```

## Key Concepts

- **Hash Key**: Partition key that determines data distribution
- **Range Key**: Sort key for ordering items within a partition
- **GSI**: Allows querying by different attributes (email in this case)
