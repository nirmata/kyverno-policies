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

resource "aws_iam_role" "example" {
  name = "example-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}

resource "aws_eks_cluster" "example" {
  name     = "example-cluster"
  role_arn = aws_iam_role.example.arn

  vpc_config {
    subnet_ids = ["subnet-12345", "subnet-67890"]
  }
}

# remote_access block is present without ec2_ssh_key and without source_security_group_ids
resource "aws_eks_node_group" "good_example" {
  cluster_name    = aws_eks_cluster.example.name
  node_role_arn   = aws_iam_role.example.arn
  subnet_ids      = ["subnet-12345", "subnet-67890"]
  node_group_name = "good-example-node-group"

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  remote_access {
    
  }
}


