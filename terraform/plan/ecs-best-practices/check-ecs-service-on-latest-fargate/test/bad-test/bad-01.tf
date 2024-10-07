terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.32"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_ecs_cluster" "example_cluster" {
  name = "example-cluster"
}

resource "aws_ecs_service" "example" {
  name    = "example"
  launch_type = "FARGATE"
  platform_version = "1.3.0"
  cluster = aws_ecs_cluster.example_cluster.id
}
