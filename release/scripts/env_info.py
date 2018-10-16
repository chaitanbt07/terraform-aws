import boto3
import json
import sys

dynamodb = boto3.client('dynamodb', region_name='ap-south-1', aws_access_key_id=sys.argv[1], aws_secret_access_key=sys.argv[2])

try:

    table = dynamodb.create_table(
        TableName='terraform_data',
        KeySchema=[
            {
                'AttributeName': 'workspace',
                'KeyType': 'HASH'
            }
        ],
        AttributeDefinitions=[
            {
                'AttributeName': 'workspace',
                'AttributeType': 'S'
            }
        ],
        ProvisionedThroughput={
            'ReadCapacityUnits': 5,
            'WriteCapacityUnits': 5
        }
    )
    print("TableARN: " + str(table['TableDescription']['TableArn']))
    print("TableID: " + str(table['TableDescription']['TableId']))
    print("TableRequestID: " + str(table['ResponseMetadata']['RequestId']))
    print("TableCreationDate: " + str(table['ResponseMetadata']['HTTPHeaders']['date']))
    #table.meta.client.get_waiter('table_exists').wait(TableName='terraform_data')
    print(table.item_count)
except Exception as e:
    print("Table exists already, " + str(e))
