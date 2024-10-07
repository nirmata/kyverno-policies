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

resource "aws_rds_cluster" "good_rds_db_cluster" {
  cluster_identifier   = "good-rds-db-cluster-01"
  engine               = "aurora-mysql"
  master_username      = "admin"
  master_password      = "admin123"
  deletion_protection  = true
}
