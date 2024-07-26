You can control access to your Lambda function URLs using the AuthType parameter combined with resource-based policies attached to your specific function. The configuration of these two components determines who can invoke or perform other administrative actions on your function URL.

The AuthType parameter determines how Lambda authenticates or authorizes requests to your function URL. When you configure your function URL, you must specify one of the following AuthType options:

- **AWS_IAM** – Lambda uses AWS Identity and Access Management (IAM) to authenticate and authorize requests based on the IAM principal's identity policy and the function's resource-based policy. Choose this option if you want only authenticated users and roles to invoke your function via the function URL.

- **NONE** – Lambda doesn't perform any authentication before invoking your function. However, your function's resource-based policy is always in effect and must grant public access before your function URL can receive requests. Choose this option to allow public, unauthenticated access to your function URL.

You can use the [AWS Lambda function URL Block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function_url) to set the Authorization Type.

```
resource "aws_lambda_function_url" "test_latest" {
  function_name      = aws_lambda_function.test.function_name
  authorization_type = "NONE"
}

resource "aws_lambda_function_url" "test_live" {
  function_name      = aws_lambda_function.test.function_name
  qualifier          = "my_alias"
  authorization_type = "AWS_IAM"

  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}
```

This policy checks whether you've set the authorization type of the AWS Lambda function to NONE. If you've, the policy will give you failing checks else passing checks.

In order to test this policy, use the following commands:

1. Navigate to the `aws/lambda/terraform/check-url-auth-type` directory. All the payloads along with Terraform files are present in the `test` directory.

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
   kyverno-json scan --payload good-payload.json --policy check-url-auth-type.yaml --bindings ./binding.yaml
   ```
   Since you've set the *authorization type* not equal to *NONE*, the policy will give you passing checks. Run the same command against the bad-paylod present in the *bad-test* directory and you'll get failing checks. This can be done something like:
   ```
   kyverno-json scan --payload bad-payload.json --policy check-x-ray-tracing-enabled.yaml --bindings ./binding.yaml
   ```