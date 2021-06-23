import json
import boto3
from botocore.exceptions import ClientError

client = boto3.client('dynamodb')

def lambda_handler(event, context):
  try:
    data = client.put_item(
    TableName='MyDb',
    Item={
        'myId': {
          'N': event['myId']
        },
        'value': {
          'S': event['value']
        }
      },
      ConditionExpression='attribute_not_exists(myId)'
    )
  except ClientError as e:
    return {"code":e.response}
  else:
    return {"code":200}