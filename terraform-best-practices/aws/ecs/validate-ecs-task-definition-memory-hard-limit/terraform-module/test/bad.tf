module "ecs_container_definition" {
  source = "terraform-aws-modules/ecs/aws//modules/container-definition"
  name      = "example"
  image     = "public.ecr.aws/aws-containers/ecsdemo-frontend:776fd50"
  port_mappings = [
    {
      name          = "ecs-sample"
      containerPort = 80
      protocol      = "tcp"
    }
  ]
  
  tags = {
    Environment = "dev"
    Terraform   = "true"
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
