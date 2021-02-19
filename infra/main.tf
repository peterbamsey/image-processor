module "bucket-a" {
  source = "./modules/s3"

  bucket-name = var.bucket-a-name
  environment = var.environment
}

module "bucket-b" {
  source = "./modules/s3"

  bucket-name = var.bucket-b-name
  environment = var.environment
}

module "lambda" {
  source        = "./modules/lambda"
  account-id    = data.aws_caller_identity.id.account_id
  environment   = var.environment
  function-name = "image-processor"
  region        = var.region
}

data "aws_caller_identity" "id" {}