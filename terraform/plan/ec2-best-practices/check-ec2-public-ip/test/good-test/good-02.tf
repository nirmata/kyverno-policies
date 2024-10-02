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
  instance_type = "t2.micro"
  image_id      = ""

  network_interfaces {
    associate_public_ip_address = false
  }
}