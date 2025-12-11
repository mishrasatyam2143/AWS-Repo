def lambda_handler(event, context):
    """
    Sample Lambda function that returns a greeting.
    Use this to test deployment and CloudWatch logs.
    """
    name = event.get('name', 'world')
    return {
        "statusCode": 200,
        "body": f"Hello, {name}!"
    }
