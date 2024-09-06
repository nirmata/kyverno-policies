In AWS Lambda, code signing refers to the process of digitally signing your Lambda function's deployment package to ensure its integrity and authenticity. This is especially important for verifying that the code running in your Lambda function has not been tampered with and that it originates from a trusted source. Terraform allows you to configure code signing for your AWS Lambda functions using the code_signing_config_arn attribute.

In your Terraform configuration, you reference the created code signing profile using its ARN *(code_signing_config_arn)* in the *aws_lambda_function* resource block.

```
resource "aws_lambda_function" "my_lambda_function" {
  function_name    = "my-lambda-function"
  handler          = "index.handler"
  runtime          = "nodejs14.x"
  code_signing_config_arn = "arn:aws:signer:us-west-2:123456789012:signing-profile/example_signing_profile"
  role             = aws_iam_role.lambda_role.arn
  filename         = "path/to/lambda_function.zip"
}
```

In this configuration:

- `code_signing_config_arn` specifies the ARN of the code signing profile created in AWS Signer.
- `filename` refers to the path to your Lambda function's deployment package (ZIP file).

You need to make sure that the *code_signing_config_arn* attribute is provided a valid string value in the *aws_lambda_function* resource block. If you do, the Policy will give you passing checks else failing checks.

In order to test this policy, use the following commands:

1. Navigate to the `aws/lambda/terraform/check-lambda-code-signing` directory. All the payloads along with Terraform files are present in the `test` directory.

2. Assume you're trying to get the payload using the *main.tf* file, use the following commands:
   ```
   terraform plan -out tfplan.binary
   ```
3. Convert this binary into JSON payload using `terraform show` command
   ```
   terraform show -json tfplan.binary | jq > payload.json
   ```
4. Test your payload against the policy using `kyverno-json scan` command
   ```
   kyverno-json scan --payload good-payload.json --policy check-lambda-code-signing.yaml --bindings ./binding.yaml
   ```
   Since you have provided a valid string value to the *code_signing_config_arn* attribute in the *aws_lambda_function* resource block, the policy will give you passing checks. If you would have specifed an empty string or might have not used the attribute, the Policy will give you failing checks. 

   In order to test the policy for bad payload, run the following command:
   ```
   kyverno-json scan --payload bad-payload.json --policy check-lambda-code-signing.yaml --bindings ./binding.yaml
   ```
