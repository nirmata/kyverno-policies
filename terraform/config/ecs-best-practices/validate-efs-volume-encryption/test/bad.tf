resource "aws_ecs_task_definition" "bad_service" {
  family                = "bad-service"
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

  volume {
    name = "service-storage"

    efs_volume_configuration {
      file_system_id          = "fs-0123456789abcdef0"
      root_directory          = "/opt/data"
      transit_encryption_port = 2999
    }
  }
}

resource "aws_ecs_task_definition" "good_service" {
  family                = "good-service"
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

  volume {
    name = "service-storage"

    efs_volume_configuration {
      file_system_id          = "fs-0123456789abcdef0"
      root_directory          = "/opt/data"
      transit_encryption      = "ENABLED"
      transit_encryption_port = 2999
    }
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