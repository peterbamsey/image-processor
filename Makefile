SHELL := /bin/bash

PROJECT_ROOT=$(shell pwd)
TEST_DST=/project

TF_SRC="$(shell pwd)/infra"
TF_DST=/workspace

AWS_REGION=eu-west-2
AWS_STATE_BUCKET=bamsey-net-image-processor-state
AWS_IMAGE_BUCKET_A=bamsey-net-image-processor-a
AWS_IMAGE_BUCKET_B=bamsey-net-image-processor-b

TEST_IMAGE_UPLOAD_PATH=$(TEST_DST)/tests/
TEST_IMAGE_DOWNLOAD_PATH=$(TEST_DST)/tests/results/
TEST_IMAGE=test.jpg
IMAGE_UPLOAD_BUCKET=bamsey-net-image-processor-a

init: build
	sudo rm -rf $(TF_SRC)/{.terraform,modules/lambda/build/} && sudo rm -f $(TF_SRC)/.terraform.lock.hcl

build:
	docker build -t terraform-local -f Dockerfile.Terraform .

tf-init: init
	docker run -i -t -w $(TF_DST) -v $(TF_SRC):$(TF_DST) -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY \
		terraform-local:latest init \
		-backend-config "bucket=$(AWS_STATE_BUCKET)" \
		-backend-config "key=environments/test/terraform.tfstate" \
		$(TF_DST)

tf-format: tf-init
	docker run -i -t -w $(TF_DST) -v $(TF_SRC):$(TF_DST) \
		terraform-local:latest \
		fmt -recursive $(TF_DST)

tf-validate: tf-format
	docker run -i -t -w $(TF_DST) -v $(TF_SRC):$(TF_DST) \
		terraform-local:latest \
		validate \
		$(TF_DST)

tf-plan: tf-validate
		docker run -i -t -w $(TF_DST) -v $(TF_SRC):$(TF_DST) -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY \
			terraform-local:latest \
 			plan \
			-refresh=true \
			-input=false \
			-var "environment=test" \
			-var "region=$(AWS_REGION)" \
			-var "bucket-a-name=$(AWS_IMAGE_BUCKET_A)" \
			-var "bucket-b-name=$(AWS_IMAGE_BUCKET_B)" \
			$(TF_DST)

tf-apply: tf-plan
		docker run -i -t -w $(TF_DST) -v $(TF_SRC):$(TF_DST) -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY \
			terraform-local:latest \
 			apply \
			-refresh=true \
			-input=false \
			-var "environment=test" \
			-var "region=$(AWS_REGION)" \
			-var "bucket-a-name=$(AWS_IMAGE_BUCKET_A)" \
			-var "bucket-b-name=$(AWS_IMAGE_BUCKET_B)" \
			$(TF_DST)

# Run once to create S3 bucket to hold TF state
tf-state-bucket-init:
	docker run -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY --rm -it amazon/aws-cli s3 mb s3://$(AWS_STATE_BUCKET) --region $(AWS_REGION)
	docker run -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY --rm -it amazon/aws-cli --region $(AWS_REGION) s3api put-bucket-versioning --bucket $(AWS_STATE_BUCKET) --versioning-configuration Status=Enabled

test-upload:
	docker run -w $(TF_DST) -v $(PROJECT_ROOT):$(TEST_DST) -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY --rm -it amazon/aws-cli s3 cp $(TEST_IMAGE_UPLOAD_PATH)$(TEST_IMAGE) s3://$(IMAGE_UPLOAD_BUCKET)/$(TEST_IMAGE)

test-download:
	echo "Wating for file..."
	sleep 15
	docker run -w $(TF_DST) -v $(PROJECT_ROOT):$(TEST_DST) -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY --rm -it amazon/aws-cli s3 cp s3://$(AWS_IMAGE_BUCKET_B)/$(TEST_IMAGE) $(TEST_IMAGE_DOWNLOAD_PATH)$(TEST_IMAGE)
	if identify -verbose $(PROJECT_ROOT)/tests/results/$(TEST_IMAGE) | grep -i exif; then echo "Exif data found in test file: FAIL"; else echo "No Exif data found in test file: SUCCESS!"; fi

test-all: test-upload test-download

