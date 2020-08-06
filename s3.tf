# Manage states on S3

# terraform {
#   backend "s3" {
#     bucket  = "aws-terraform-06082020"
#     key    = "terraform.tfstate.d"
#     region  = "eu-west-1"
#     encrypt = true
#     dynamodb_table = "terraform-up-and-running-locks"
#   }

# }

# resource "aws_s3_bucket" "aws-terraform" {
#   bucket = "aws-terraform-06082020"
#   versioning {
#     enabled = true
#   }
#   server_side_encryption_configuration {
#     rule {
#       apply_server_side_encryption_by_default {
#         sse_algorithm = "AES256"
#       }
#     }
#   }
#   acl  = "private"
# }

# resource "aws_s3_bucket_public_access_block" "aws-terraform" {
#   bucket = aws_s3_bucket.aws-terraform.id

#   block_public_acls       = true
#   block_public_policy     = true
#   ignore_public_acls      = true
#   restrict_public_buckets = true
# }

# resource "aws_dynamodb_table" "terraform_locks" {
#   name         = "terraform-up-and-running-locks"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "LockID"
#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }