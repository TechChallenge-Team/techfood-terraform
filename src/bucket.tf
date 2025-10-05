#resource "aws_s3_bucket" "bucket-backend" {
#  bucket = var.projectName
#  tags   = var.tags
#}

resource "aws_s3_bucket" "lambda_artifacts" {
  bucket        = lower("${var.projectName}-lambda-artifacts-${data.aws_caller_identity.current.account_id}-${var.region_default}")
  force_destroy = true

  tags = merge(var.tags, { Service = "lambda-artifacts" })
}