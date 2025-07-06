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

resource "aws_ecs_task_definition" "task" {
  family = "service"
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
      ],
      "environment" : [
        {
          "name"  : "ECS_ENGINE_AUTH_DATA",
          "value" : "EXAMPLE_VALUE"
        }
      ]
    }
  ]
  DEFINITION
}