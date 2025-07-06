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

resource "aws_db_instance" "skip_instance" {
  identifier        = "skip-instance-01"
  instance_class    = "db.m5.large"
  engine            = "oracle-ee" # Engine is oracle-ee. Hence, this test is skipped.
  username          = "master_username"
  password          = "secure_password"
  allocated_storage = 10
  skip_final_snapshot = true
}
