resource "aws_ecs_task_definition" "good_task_1" {
  family = "service"
  # pid_mode = "task"
  container_definitions    = <<DEFINITION
  [
    {
      "name"      : "foo-task",
      "image"     : "nginx:1.23.1",
      "cpu"       : 512,
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

resource "aws_ecs_task_definition" "good_task_2" {
  family = "service-2"
  # pid_mode = "task"
  container_definitions    = <<DEFINITION
  [
    {
      "name"      : "bar-task",
      "image"     : "httpd:2.4",
      "cpu"       : 256,
      "memory"    : 1024,
      "essential" : true,
      "portMappings" : [
        {
          "containerPort" : 8080,
          "hostPort"      : 8080
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
