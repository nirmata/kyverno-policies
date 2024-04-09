resource "aws_ecs_service" "service" {
  name             = "foo-service"
  service_connect_configuration {
    enabled = true
  }
  lifecycle {
    ignore_changes = [task_definition]
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
