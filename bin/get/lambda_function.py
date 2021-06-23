import json
import boto3
#just checking for deplotment 
client = boto3.client('dynamodb')

def lambda_handler(event, context):
    data = client.get_item(
    TableName='MyDb',
    Key={
        'myId': {'N': event["queryStringParameters"]['myId']}
      }
    )
    return {
    "statusCode": "200",
    "body": str(data["Item"]["value"])
}