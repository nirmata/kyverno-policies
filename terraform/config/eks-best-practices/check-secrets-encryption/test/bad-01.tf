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

resource "aws_kms_key" "example" {
  description = "KMS key for EKS cluster encryption"
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

resource "aws_iam_role_policy_attachment" "example_role_policy_attachment" {
  role       = aws_iam_role.example_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_eks_cluster" "good_example_1" {
  name     = "good_example_1"
  role_arn = aws_iam_role.example_role.arn

  vpc_config {
    subnet_ids = ["subnet-01"]

    endpoint_public_access = false
  }

  encryption_config {
    provider {
      key_arn = aws_kms_key.example.arn
    }

    resources = ["secrets"]
  }
}

resource "aws_eks_cluster" "bad_example_1" {
  name     = "bad_example_1"
  role_arn = aws_iam_role.example_role.arn

  vpc_config {
    subnet_ids = ["subnet-01"]

    endpoint_public_access = false
  }
}
