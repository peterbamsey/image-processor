# image-processor
This project is an example of event driven image processing using AWS S3 buckets and a Lambda function.

## What does it do
![Diagram](/diagram/diagram.jpg)
<br>
The project contains two S3 buckets, one for file upload and one for post processing storage, and one Lambda function to perform the image manipulation - which in this case is stripping Exif data from the image.
<br><br>
The Lambda function is subscribed to the upload bucket and receives a notification event when a new file arrives.  The Lambda function gets the source S3 bucket name and file key from the event and removes the Exif data by opening the file with the Pillow library and saving it to the destination S3 bucket.
<br><br>
The project also creates two users.  user-a who can read and write bucket-a and user-b who can only read bucket-b.

## Deploying
The project contains a Makefile to simplify deployment. Infrastructure configuration is managed by Terraform, launched via a Docker container.

### Initial setup
Update the variables at the top of the Makefile to match your desired setup.
<br>

Export your AWS Access and Secret Access key in your shell:
<br>
`export AWS_ACCESS_KEY_ID=AKIADSFGSF234WRE; export AWS_SECRET_ACCESS_KEY=SAdfoksdfpija093jla`

Setup the S3 bucket used by Terraform to hold the state file:
<br>
`make state-bucket-init`

Deploy the infrastructure including the Lambda function:
<br>
`make tf-apply`

Test the processor by uploading a test JPEG file:
<br>
`make test-upload`

Test the processed image no longer contains Exif data:
<br>
`make test-download`


## Prerequisites
* docker
* make
* imagemagick for testing for Exif data (apt-get install imagemagick)

## Known Issues
Exporting AWS credentials in your shell is bad practice.
