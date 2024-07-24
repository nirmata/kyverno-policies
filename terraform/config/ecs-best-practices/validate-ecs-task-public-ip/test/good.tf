resource "aws_ecs_service" "service" {
  name             = "foo-service"
  cluster          = aws_ecs_cluster.cluster.id
  desired_count    = 1
  launch_type      = "EC2"
  network_configuration {
    assign_public_ip = false
    subnets          = [aws_subnet.subnet.id]
  }
  lifecycle {
    ignore_changes = [task_definition]
  }
}

resource "aws_ecs_service" "service_2" {
  name             = "bar-service"
  cluster          = aws_ecs_cluster.cluster.id
  desired_count    = 1
  launch_type      = "EC2"
  network_configuration {
    assign_public_ip = false
    subnets          = [aws_subnet.subnet.id]
  }
  lifecycle {
    ignore_changes = [task_definition]
  }
}

resource "aws_ecs_cluster" "cluster" {
  name = "cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, 1) ## takes 10.0.0.0/16 --> 10.0.1.0/24
  map_public_ip_on_launch = true
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    name = "main"
  }
}

variable "vpc_cidr" {
  description = "CIDR block for main"
  type        = string
  default     = "10.0.0.0/16"
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