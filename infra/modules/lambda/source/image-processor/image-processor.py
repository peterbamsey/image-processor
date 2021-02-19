import json
from io import BytesIO
import os
import boto3
from PIL import Image


def lambda_handler(event, context):

    print(event)

    source_bucket_name = event['Records'][0]['s3']['bucket']['name']
    source_bucket_arn = event['Records'][0]['s3']['bucket']['arn']
    source_bucket_key = event['Records'][0]['s3']['object']['key']

    destination_bucket_arn = os.environ['DESTINATION_BUCKET_ID']

    print(source_bucket_name,source_bucket_arn,source_bucket_key)

    s3_source = boto3.resource('s3')
    s3_destination = boto3.client('s3')

    source_bucket = s3_source.Bucket(source_bucket_name)

    img_object = source_bucket.Object(source_bucket_key)
    file_byte_string = img_object.get()['Body'].read()

    img = Image.open(BytesIO(file_byte_string))
    buffer = BytesIO()
    img.save(buffer, 'JPEG')
    buffer.seek(0)

    response = s3_destination.put_object(
        Bucket=destination_bucket_arn,
        Key=source_bucket_key,
        Body=buffer)

    print(response)

    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
