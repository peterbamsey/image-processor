SHELL := /bin/bash

TF_SRC="$(shell pwd)/infra"
TF_DST=/workspace

#AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
#AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
AWS_REGION=eu-west-2
AWS_STATE_BUCKET=bamsey-net-image-processor-state
AWS_IMAGE_BUCKET_A=bamsey-net-image-processor-a
AWS_IMAGE_BUCKET_B=bamsey-net-image-processor-b


init: build
	sudo rm -rf $(TF_SRC)/.terraform && sudo rm -f $(TF_SRC)/.terraform.lock.hcl

build:
	docker build -t terraform-local -f Dockerfile.Terraform .

tf-init: init
	docker run -i -t -w /workspace -v $(TF_SRC):$(TF_DST) -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY \
		terraform-local:latest init \
		-backend-config "bucket=$(AWS_STATE_BUCKET)" \
		-backend-config "key=environments/test/terraform.tfstate" \
		$(TF_DST)

tf-format: tf-init
	docker run -i -t -w /workspace -v $(TF_SRC):$(TF_DST) \
		terraform-local:latest \
		fmt -recursive $(TF_DST)

tf-validate: tf-format
	docker run -i -t -w $(TF_DST) -v $(TF_SRC):$(TF_DST) \
		terraform-local:latest \
		validate \
		$(TF_DST)

tf-plan: tf-validate
		docker run -i -t -w /workspace -v $(TF_SRC):$(TF_DST) -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY \
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
		docker run -i -t -w /workspace -v $(TF_SRC):$(TF_DST) -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY \
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
