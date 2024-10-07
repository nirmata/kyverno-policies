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
  name_prefix   = "example"
  image_id      = "ami-775287582"
  instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "example" {
  max_size           = 3
  min_size           = 1

  launch_template {
    id      = aws_launch_template.example.id
  }
}