import os, boto3

def _get_table():
    return boto3.resource('dynamodb', region_name=os.environ['AWS_REGION']).Table(os.environ['DYNAMODB_TABLE'])

def put_mapping(short_id: str, url: str):
    _get_table().put_item(
        Item={
            'id': short_id,
            'url': url
        }
    )

def get_mapping(short_id: str):
    response = _get_table().get_item(
        Key={'id': short_id}
    )
    return response.get('Item')



