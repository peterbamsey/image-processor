resource "aws_lambda_permission" "allow-bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda-arn
  principal     = "s3.amazonaws.com"
  source_arn    = var.s3-bucket-arn
}

resource "aws_s3_bucket_notification" "bucket-notification" {
  bucket = var.s3-bucket-id

  lambda_function {
    lambda_function_arn = var.lambda-arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".jpg"
  }

  depends_on = [aws_lambda_permission.allow-bucket]
}