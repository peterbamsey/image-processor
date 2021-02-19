resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket-name
  acl    = "private"

  tags = {
    Name = var.bucket-name
    Env  = var.environment
  }
}