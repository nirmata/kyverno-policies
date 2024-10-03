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

resource "aws_secretsmanager_secret" "rds_secret" {
  name = "rds-db-secret"

  tags = {
    Name = "rds-db-secret"
  }
}

resource "aws_secretsmanager_secret_version" "rds_secret_version" {
  secret_id     = aws_secretsmanager_secret.rds_secret.id
  secret_string = jsonencode({
    username = "admin"
    password = "admin1234"
  })
}

resource "aws_db_proxy" "bad_db_proxy" {
  name                   = "bad-db-proxy-02"
  engine_family          = "POSTGRESQL"
  role_arn               = "arn:aws:iam::xxxx:role/aws-service-role/rds.amazonaws.com/AWSServiceRoleForRDS"
  vpc_subnet_ids         = ["subnet-id-1", "subnet-id-2"]

  auth {
    auth_scheme = "SECRETS"
    secret_arn  = aws_secretsmanager_secret.rds_secret.arn
  }
}
