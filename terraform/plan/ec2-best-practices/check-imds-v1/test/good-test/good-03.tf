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

resource "aws_launch_configuration" "example_1" {
  instance_type = "t2.micro"
  image_id      = ""

  metadata_options {
    http_endpoint = "disabled"
  }
}

resource "aws_launch_configuration" "example_2" {
  instance_type = "t2.micro"
  image_id      = ""

  metadata_options {
    http_tokens   = "required"
  }
}

resource "aws_launch_configuration" "example_3" {
  instance_type = "t2.micro"
  image_id      = ""

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
}
