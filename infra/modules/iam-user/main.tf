resource "aws_iam_user" "user" {
  name = var.user-name
}

resource "aws_iam_user_policy" "policy" {
  name = var.user-policy-name
  user = aws_iam_user.user.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = var.iam-actions,
        Effect   = var.iam-effect,
        Resource = var.resource-arns
      }
    ]
  })
}
