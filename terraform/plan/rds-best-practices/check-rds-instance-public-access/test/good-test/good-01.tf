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

resource "aws_db_instance" "good-db-instance" {
  allocated_storage   = 10
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro"
  db_name             = "mydb"
  username            = "username"
  password            = "password"
  publicly_accessible = false
  skip_final_snapshot = true
}
