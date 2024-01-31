terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "test-bucket" {
  bucket = "tf-bucket-demo"
}

resource "aws_s3_bucket_public_access_block" "test-bucket" {
  bucket = aws_s3_bucket.example.id

  block_public_acls       = false
  block_public_policy     = true
  ignore_public_acls      = false
  restrict_public_buckets = true
}
