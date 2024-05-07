# Define provider
provider "aws" {
  region = "us-east-1" # Change to your desired region
}

# Create S3 bucket
resource "aws_s3_bucket" "myteam_bucket" {
  bucket = "myteam"
}

# Create subfolders B and C
resource "aws_s3_bucket" "subfolder_b" {
  bucket = "${aws_s3_bucket.myteam_bucket.bucket}/b"
}

resource "aws_s3_bucket" "subfolder_c" {
  bucket = "${aws_s3_bucket.myteam_bucket.bucket}/c"
}

# Create subfolders 1b, 2b, 1c, and 2c
resource "aws_s3_bucket" "subfolder_1b" {
  bucket = "${aws_s3_bucket.myteam_bucket.bucket}/b/1b"
}

resource "aws_s3_bucket" "subfolder_2b" {
  bucket = "${aws_s3_bucket.myteam_bucket.bucket}/b/2b"
}

resource "aws_s3_bucket" "subfolder_1c" {
  bucket = "${aws_s3_bucket.myteam_bucket.bucket}/c/1c"
}

resource "aws_s3_bucket" "subfolder_2c" {
  bucket = "${aws_s3_bucket.myteam_bucket.bucket}/c/2c"
}

# Create IAM role for Football service account
resource "aws_iam_role" "football_service_account_role" {
  name               = "FootballServiceAccountRole"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = {
        AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/football"
      }
      Action    = "sts:AssumeRole"
    }]
  })

  # Attach S3 access policy
  inline_policy {
    name = "S3AccessPolicy"
    policy = jsonencode({
      Version   = "2012-10-17"
      Statement = [
        {
          Effect    = "Allow"
          Action    = ["s3:GetObject", "s3:ListBucket"]
          Resource  = [
            aws_s3_bucket.subfolder_b.arn,
            aws_s3_bucket.subfolder_c.arn,
            "${aws_s3_bucket.subfolder_b.arn}/1b/*",
            "${aws_s3_bucket.subfolder_c.arn}/1c/*",
          ]
        },
        {
          Effect    = "Allow"
          Action    = ["s3:GetObject", "s3:ListBucket", "s3:PutObject", "s3:DeleteObject"]
          Resource  = [
            aws_s3_bucket.subfolder_2b.arn,
            aws_s3_bucket.subfolder_2c.arn,
          ]
        },
      ]
    })
  }
}

# Data source to fetch current AWS account ID
data "aws_caller_identity" "current" {}
