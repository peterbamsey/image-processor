variable "iam-actions" {
  description = "The IAM policy action"
  type        = list(string)
}

variable "iam-effect" {
  description = "The IAM effect in the policy"
  type        = string
}

variable "resource-arns" {
  description = "The IAM permission action to allow for the user"
  type        = list(string)
}

variable "user-name" {
  description = "The name of the IAM user"
  type        = string
}

variable "user-policy-name" {
  description = "The name of the IAM policy for the user"
  type        = string
}