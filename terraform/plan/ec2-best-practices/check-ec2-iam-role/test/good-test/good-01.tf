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

resource "aws_instance" "example" {
  ami           = "ami-01572eda7c4411960" 
  instance_type = "t2.micro"
  iam_instance_profile = "example_iam_instance_profile"
  
  tags = {
    Name = "example_ec2"
  }
}

