terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
  access_key = "ASIA4JFRUINQBWNEIM6Y"
  secret_key = "Ws1gpfLcATSsRnk/o3tNbieqaWZcLGhXOXzs+UyH"
  token = "IQoJb3JpZ2luX2VjEGQaCXVzLWVhc3QtMiJHMEUCIQC5s3XZqe0G6p4C8sqremQwG8Qpn0A7j1V/XhmRRnvDHgIgHspQ9p51MAHsS4IIeg+Iat4DcWR50l9VOgMaD1dnVrMqjgMILRADGgw4NDQzMzM1OTc1MzYiDDJ8P2dn2rVnqFDv7SrrAvGQ5l2a64fPDdxN56wII6zF9YkPHMkYIHgq/11WnNQpAhE1c0EbmZdwObJA9/rdHrSQsmhSuUBAiFU9Ys5Ro/I6fNt7zqotQ/trvgjMDwG4+q3InowH1zuE+1fa4ewQGSG9jrJvlT7X7hWa65lw8Qr5XGSddGeKtby/kDckqkVOJV+wUb2s3cuLW9j7x7hsE/xJRVUA70z0i5rhmXsiR9JP7vFMhmZDu9yH46375tGE7Ih7Mwtd8DejPwlpeMBUMGlcc+xAahcUxP8n+fjwAuZrLO+v0f96uWEHo87foB/SnpGwbitCWGt8UcDtmN0939P9MiMHLitorCtrpQyeUk1DPTdzwNww0nRKEjwtTw9MqRkTI0PG/5SWScphhxjxb/268qJIjS3FE+xG4hulr+gj3KId0sAbPRlUUv12SIbjgH6esD//S5JmxzBMTPQ+8A38fXSiZQ1ZQL1BaktLGbf0x1o+TafmeQSenjCm5eitBjqmAZlxiRWfntKUiH64SawiWbyDJ7kJMfoq6pT59EtNIOa/8rHfx4+aOFAqYCAClJe6Hw8d4RIpfewlaqiJL7Gw5uXc4IcepdOi2KMZ0f32k5HIMa8uKZBWpaUsH8tyWlKKjzRAMM/LsoGSovknkmmwLLkAJ+0Y6YySyQQqv1SpHQuyv7ySbk2qS7+kPplkK8+LQiB21NpHZfGirS6bnRrwLpHZ3TAzNF0="
}

resource "aws_s3_bucket" "example" {
  bucket = "test-bucket-demo-18012003"
}

resource "aws_s3_bucket_lifecycle_configuration" "example" {
  bucket = aws_s3_bucket.example.id

  rule {
    id = "rule-1"
    status = "Enabled"
    abort_incomplete_multipart_upload {
        days_after_initiation = 12
    }
  }
}
