Server access logging is a feature provided by Amazon Simple Storage Service (S3) that allows you to track and log requests for access to your S3 bucket. When enabled, S3 will generate log records for each request made to the bucket, recording details such as the requester's IP address, the request time, the HTTP method used, the requested resource, the response status code, and more.

In order to enable server access logging for your S3 Bucket with the help of Terraform, you need to use *aws_s3_server_access_logging* block. The required fields are bucket name, target bucket name, and target bucket prefix.

```
resource "aws_s3_bucket_logging" "example" {
  bucket = aws_s3_bucket.example.id

  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}
```

If you're not using the *aws_s3_bucket_logging* block in your Terraform file, this means that server-access-logging is set to be disabled. By default, it is set to disabled as well.

**In order to test this policy, perform the following steps:**

1. Navigate to the `aws/s3/terraform/enable-s3-server-access-logging` directory. All the payloads along with Terraform files are present in the `test` directory.
   
2. Assume you're trying to get the payload using the *good-terraform.tf* file, use the following commands:
   ```
   terraform plan -out tfplan.binary
   ```
3. Convert this binary into JSON payload using `terraform show` command
   ```
   terraform show -json tfplan.binary | jq > payload.json
   ```
4. Test your payload against the policy using `kyverno-json scan` command
   ```
   kyverno-json scan --payload payload.json --policy enable-kms-encryption.yaml
   ```
   Since you've used the *aws_s3_bucket_logging* block in your Terraform file, this means that the server access loggin is set to be Enabled. Hence, the policy will give you Passing checks. If you try to remove the block, get a payload out of it(*bad-terraform.tf*), and test your policy against the *bad-payload.json* again using the above command, you'll get FAIL checks.
   