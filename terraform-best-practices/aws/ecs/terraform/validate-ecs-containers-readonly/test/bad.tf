module "ecs_container_definition" {
  source = "terraform-aws-modules/ecs/aws//modules/container-definition"
  name      = "example"
  readonly_root_filesystem = false
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
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configuring docker and AWS as providers

provider "aws" {
  region  = "us-west-1"
  profile = "foo"
}
