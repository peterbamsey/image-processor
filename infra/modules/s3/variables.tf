variable "bucket-name" {
  description = "The S3 bucket name"
  type        = string
}

variable "environment" {
  description = "The environment that the resources live in e.g prod or beta"
  type        = string
}
