#resource "aws_s3_bucket" "bucket-backend" {
#  bucket = var.projectName
#  tags   = var.tags
#}

resource "aws_s3_bucket" "lambda_artifacts" {
  bucket        = "${var.projectName}-lambda-artifacts-bucket"
  force_destroy = true

  tags = merge(var.tags, {
    Service = "lambda-artifacts" 
  })
}