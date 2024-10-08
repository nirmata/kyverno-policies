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
  region = "us-west-2" # Updated region
}

resource "aws_rds_cluster" "skip_serverless_aurora_cluster" {
  cluster_identifier = "skip-serverless-aurora-cluster"
  engine             = "aurora-mysql"
  engine_mode        = "serverless" # Aurora Serverless v1 is skipped
  master_username    = "admin"
  master_password    = "secret99"
  backup_retention_period = 7
  skip_final_snapshot = true
}
