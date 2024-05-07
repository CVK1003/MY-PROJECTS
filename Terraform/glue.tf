# Define variables
variable "s3_bucket_name" {
  type        = string
  description = "Name for the S3 bucket"
  default     = "otdpaas-poc-s3"
}

variable "glue_database_name" {
  type        = string
  description = "This is a poc to provision Glue database"
  default     = "poc_test_db"
}

# Create S3 bucket
resource "aws_s3_bucket" "my_s3_bucket" {
  bucket = var.s3_bucket_name
}

# Create Glue database
resource "aws_glue_database" "glue_database" {
  name = var.glue_database_name
}
