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

resource "aws_iam_role" "example_role" {
  name = "example_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      }
    }
  ]
}
EOF
}

# example1 is bad as "0.0.0.0/0" is present in public_access_cidrs
resource "aws_eks_cluster" "example1" {
  name     = "example1"
  role_arn = aws_iam_role.example.arn

  vpc_config {
    subnet_ids = ["subnet-12345"]
    endpoint_public_access = true
    public_access_cidrs = ["0.0.0.0/0"]
  }
}

# example2 is good as `endpoint_public_access` is set to false
resource "aws_eks_cluster" "example2" {
  name     = "example2"
  role_arn = aws_iam_role.example_role.arn

  vpc_config {
    subnet_ids = ["subnet-01"]
    endpoint_public_access = false
  }
}
