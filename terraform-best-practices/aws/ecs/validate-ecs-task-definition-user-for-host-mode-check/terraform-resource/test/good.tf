resource "aws_ecs_task_definition" "task" {
  family = "service"
  network_mode = "host"
  container_definitions    = <<DEFINITION
  [
    {
      "name"      : "foo-task",
      "image"     : "nginx:1.23.1",
      "cpu"       : 512,
      "privileged": false,
      "user"      : "xyz",
      "memory"    : 2048,
      "essential" : true,
      "portMappings" : [
        {
          "containerPort" : 80,
          "hostPort"      : 80
        }
      ]
    }
  ]
  DEFINITION
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