import json

def handler(event, context):
    """
    Simple Lambda function that processes events
    """
    print(f"Event received: {json.dumps(event)}")

    # Extract data from event
    name = event.get('name', 'World')
    action = event.get('action', 'greeting')

    # Process based on action
    if action == 'greeting':
        message = f"Hello, {name}!"
    elif action == 'farewell':
        message = f"Goodbye, {name}!"
    else:
        message = f"Unknown action: {action}"

    response = {
        'statusCode': 200,
        'body': json.dumps({
            'message': message,
            'input': event
        })
    }

    return response
