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
  access_key = "ASIA4JFRUINQGRB5TXNP"
  secret_key = "/Xaejacg3Snm1C7A1DwNBE7r8YxOMDkrkX4x/Cdl"
  token = "IQoJb3JpZ2luX2VjEHUaCXVzLWVhc3QtMiJHMEUCIQCltr459nPRo9ZE+g4ceKFn860zygLhpf1rOp2ItfhilQIgBkIvCtKX6aVZulngkH17Lw0jfdXZ7y/ghoQjlqtcgzIqjgMIPhADGgw4NDQzMzM1OTc1MzYiDFy0uJyWkyb+LXGmjirrAsSqyB5Hz9TAiTaQRk6VG2QB0rnKVz9xOYnVeZF/lry4TujtUrP9VTbIqk9btRBd7REt1l7UrQCjZDe6JLrXwKsEFv1+Iky5W+ZAgAYo+h6OgIEE8qnvio4eezsiXi36IRXoDVrpwidggFdzaya1haLYdmypu++LgVAs8KJR0gXKkS9QLSy0LVTINtOOPjqHSZKEdDxDkOCtJL9if1C6QtrIdC6L7ejXPgpnFmZZL5lczbhZhs/HHeVqdebKfTuAng7rKHKoooHBhX9tb2g+HC7uNaI9uicJviGtXfq5AmqRLZLmFGYPKnmxMG6t0OjxQpg//IT8UJ6ggYnrOKikQmm33oEItxUtaXtVe9E3PpzGFv7Hdbe2YR0XW4n1b6RXjMfUxUpwVgp92ylIU7Ysr1I4uF5kDZzI6s9CIw1/tD0PSa+AhM2bGUBi76dTuToAvkkX1B9ct+kxjkcu9uEgz3i8cBK/ZIhNWR6/mTCKyuytBjqmAZDdcZqAxL91vkWiy8KRl5jovTgFBW7KVvheW2+Lcbe8ngV9reoGqB6ieKfNtQp00Nvr9sNHnIIPHkdhgYptkjJGDNWkm9EbLkZKN3Baj8sdHsyX7AuHb8COBYy60T3vRqgolubbbwHiS2tF6PqdH8/7xsMm1XSUIxS9w94WVfpq1hDVq8c5vmibKiQxdp2X3TGajbQFApei8SsdkIjTzQRbNLq3CuA="
}

resource "aws_cloudtrail" "example" {
  depends_on = [aws_s3_bucket_policy.example]

  name                          = "example"
  s3_bucket_name                = aws_s3_bucket.example.id
  s3_key_prefix                 = "prefix"
  include_global_service_events = false
#   enable_logging = true
}

resource "aws_s3_bucket" "example" {
  bucket        = "tf-test-trail"
  force_destroy = true
}

data "aws_iam_policy_document" "example" {
  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.example.arn]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:${data.aws_partition.current.partition}:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/example"]
    }
  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.example.arn}/prefix/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:${data.aws_partition.current.partition}:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/example"]
    }
  }
}

resource "aws_s3_bucket_policy" "example" {
  bucket = aws_s3_bucket.example.id
  policy = data.aws_iam_policy_document.example.json
}

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_region" "current" {}