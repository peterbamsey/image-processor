variable "account-id" {
  description = "The AWS account ID"
  type        = string
}

variable "destination-bucket-arn" {
  description = "The ARN of the bucket to copy the image to"
  type        = string
}

variable "destination-bucket-id" {
  description = "The id of the bucket to copy the image to"
  type        = string
}

variable "environment" {
  description = "The environment that the resources live in e.g prod or beta"
  type        = string
}

variable "function-name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "region" {
  description = "The AWS region"
  type        = string
}

variable "source-bucket-arn" {
  description = "The ARN of the source bucket"
  type        = string
}

