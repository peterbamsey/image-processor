variable "bucket-a-name" {
  description = "The name of bucket-a - must be unique"
  type        = string
}

variable "bucket-b-name" {
  description = "The name of bucket-b - must be unique"
  type        = string
}

variable "environment" {
  description = "The environment the resources will be deployed to e.g prod or beta"
  type        = string
}

variable "region" {
  description = "The AWS region which the resources are deployed in"
  type        = string
}
