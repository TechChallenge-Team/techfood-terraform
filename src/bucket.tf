#resource "aws_s3_bucket" "bucket_backend" {
#  bucket = var.projectName
#  tags   = var.tags
#}

resource "aws_s3_bucket" "lambda_artifacts_bucket" {
  bucket        = var.lambda_artifacts_bucket_name
  force_destroy = true

  tags = merge(var.tags, {
    Service = "lambda-artifacts" 
  })
}
