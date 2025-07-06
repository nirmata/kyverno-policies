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

# No audit log publication to CloudWatch Logs
resource "aws_rds_cluster" "bad_aurora_mysql_cluster" {
  cluster_identifier = "bad-aurora-mysql-cluster"
  engine             = "aurora-mysql"
  master_username    = "admin"
  master_password    = "secret99"
  backup_retention_period = 7
  skip_final_snapshot = true
}
