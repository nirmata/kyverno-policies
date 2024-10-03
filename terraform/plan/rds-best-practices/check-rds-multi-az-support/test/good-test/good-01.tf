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

resource "aws_db_instance" "good_mysql_instance" {
  identifier          = "good-mysql-instance"
  instance_class      = "db.t3.micro"
  engine              = "mysql"
  username            = "admin"
  password            = "secret99"
  allocated_storage   = 5
  skip_final_snapshot = true
  multi_az            = true
}
