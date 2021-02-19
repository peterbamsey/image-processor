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
  source = "./modules/lambda"

  account-id             = data.aws_caller_identity.id.account_id
  destination-bucket-arn = module.bucket-b.s3-bucket-arn
  destination-bucket-id  = module.bucket-b.s3-bucket-id
  environment            = var.environment
  function-name          = "image-processor"
  region                 = var.region
  source-bucket-arn      = module.bucket-a.s3-bucket-arn
}

module "s3-to-lambda" {
  source = "./modules/s3-to-lambda"

  lambda-arn    = module.lambda.lambda-arn
  s3-bucket-arn = module.bucket-a.s3-bucket-arn
  s3-bucket-id  = module.bucket-a.s3-bucket-id
}

module "user-a" {
  source = "./modules/iam-user"

  iam-actions      = ["s3:Listbucket", "s3:PutObject", "s3:GetObject"]
  iam-effect       = "Allow"
  resource-arns    = ["${module.bucket-a.s3-bucket-arn}/*", module.bucket-a.s3-bucket-arn]
  user-name        = "user-a"
  user-policy-name = "user-a"
}

module "user-b" {
  source = "./modules/iam-user"

  iam-actions      = ["s3:List*", "s3:Get*"]
  iam-effect       = "Allow"
  resource-arns    = ["${module.bucket-b.s3-bucket-arn}/*", module.bucket-b.s3-bucket-arn]
  user-name        = "user-b"
  user-policy-name = "user-b"
}

data "aws_caller_identity" "id" {}