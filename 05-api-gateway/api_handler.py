import json

def handler(event, context):
    """
    API Gateway Lambda handler
    """
    # Extract HTTP method and path
    http_method = event.get('httpMethod', 'GET')
    path = event.get('path', '/')

    # Extract query parameters and body
    query_params = event.get('queryStringParameters') or {}
    body = event.get('body', '{}')

    print(f"Method: {http_method}, Path: {path}")

    # Route based on method and path
    if http_method == 'GET' and path == '/hello':
        name = query_params.get('name', 'World')
        response_body = {
            'message': f'Hello, {name}!',
            'method': http_method,
            'path': path
        }
        status_code = 200

    elif http_method == 'POST' and path == '/echo':
        try:
            request_body = json.loads(body)
            response_body = {
                'echo': request_body,
                'message': 'Successfully echoed your request'
            }
            status_code = 200
        except json.JSONDecodeError:
            response_body = {'error': 'Invalid JSON'}
            status_code = 400

    elif http_method == 'GET' and path == '/status':
        response_body = {
            'status': 'healthy',
            'service': 'demo-api',
            'version': '1.0.0'
        }
        status_code = 200

    else:
        response_body = {
            'error': 'Not Found',
            'message': f'No handler for {http_method} {path}'
        }
        status_code = 404

    return {
        'statusCode': status_code,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        },
        'body': json.dumps(response_body)
    }
