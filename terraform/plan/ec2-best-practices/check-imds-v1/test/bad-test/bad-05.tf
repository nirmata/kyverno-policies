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
  metadata_options {
    http_tokens = "optional"
  }
}