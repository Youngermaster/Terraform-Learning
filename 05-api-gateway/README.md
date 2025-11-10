# API Gateway + Lambda Example

This example creates a REST API using API Gateway backed by Lambda functions.

## What You'll Learn

- Creating REST APIs with API Gateway
- Defining resources and methods (GET, POST)
- Lambda proxy integration
- API deployment and stages
- Granting API Gateway permission to invoke Lambda

## Resources Created

- **demo-api**: REST API with three endpoints
  - `GET /hello` - Returns a greeting (accepts `?name=` parameter)
  - `POST /echo` - Echoes back the request body
  - `GET /status` - Returns API health status
- **api-handler**: Lambda function that processes all requests

## Usage

```bash
# Initialize and apply
terraform init
terraform apply

# The output will show the API endpoint URL
# Example: http://localhost:4566/restapis/abc123/dev/_user_request_

# Test the endpoints (replace with your actual API ID from output)
API_URL="http://localhost:4566/restapis/YOUR_API_ID/dev/_user_request_"

# GET /hello with default greeting
curl "${API_URL}/hello"

# GET /hello with custom name
curl "${API_URL}/hello?name=Alice"

# POST /echo with JSON body
curl -X POST "${API_URL}/echo" \
  -H "Content-Type: application/json" \
  -d '{"message": "Hello API", "data": [1, 2, 3]}'

# GET /status
curl "${API_URL}/status"

# List APIs
awslocal apigateway get-rest-apis

# Get API details
awslocal apigateway get-rest-api --rest-api-id YOUR_API_ID

# List resources
awslocal apigateway get-resources --rest-api-id YOUR_API_ID

# Cleanup
terraform destroy
rm -f api_handler.zip
```

## Key Concepts

- **REST API**: HTTP-based API with resources and methods
- **Resources**: URL paths in your API (/hello, /echo, /status)
- **Methods**: HTTP verbs (GET, POST, PUT, DELETE)
- **AWS_PROXY Integration**: Passes entire request to Lambda, Lambda formats response
- **Deployment**: Makes API available at an endpoint
- **Stage**: Environment name (dev, staging, prod)
