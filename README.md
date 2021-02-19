# image-processor
This project is an example of event driven image processing using AWS S3 buckets and a Lambda function.

## What does it do
![Diagram](/diagram/diagram.jpg)
The project contains two S3 buckets, one for file upload and one for post processing storage and one Lambda function to perform the image manipulation - which in this case is stipping EXIF data from the image.
<br><br>
The Lambda function is subscribed to the upload bucket and received a notification event when a new file arrives.  The Lambda gets the S3 bucket name and file key from the event and removes the EXIF data by opening the file with the Pillow library and saving it to the destination S3.

## Deploying
The project contains a Makefile to simplify deployment. Infrastructure configuration is managed by Terraform, launch via a Docker container.

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

Test the processed image no longer contains exif data:
<br>
`make test-download`


## Prerequisites
* docker
* make
* imagemagick for testing for EXIF data (apt-get install imagemagick)