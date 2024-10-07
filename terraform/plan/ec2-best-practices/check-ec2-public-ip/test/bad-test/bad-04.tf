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

resource "aws_launch_template" "example" {
  instance_type = "c6a.large"
  image_id      = "ami-02d3f9239f16d5514"

  network_interfaces {
    
  }
}

