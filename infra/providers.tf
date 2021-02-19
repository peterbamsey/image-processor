provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    region = "eu-west-2"
  }
}