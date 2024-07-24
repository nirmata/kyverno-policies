resource "aws_ecs_cluster" "good_ecs_cluster_1" {
  name = "good-cluster-1"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_cluster" "good_ecs_cluster_2" {
  name = "good-cluster-2"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# Setting up the configuration for using Docker and AWS providers

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~>2.20.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configuring docker and AWS as providers
provider "docker" {}

provider "aws" {
  region  = "us-west-1"
}
