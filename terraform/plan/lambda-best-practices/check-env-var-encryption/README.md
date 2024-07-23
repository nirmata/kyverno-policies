Encrypting environment variables of an AWS Lambda function using Terraform involves several steps within Terraform's resource blocks. First, you create a Key Management Service (KMS) key using the aws_kms_key resource block, specifying details like description, key rotation, and deletion window. This key will be used to encrypt and decrypt the environment variables. Next, in the aws_lambda_function resource block that defines your Lambda function, you specify the kms_key_arn parameter with the ARN of the KMS key created earlier. Within the environment block of the Lambda function resource, you define the environment variables you want to encrypt, setting their values as plaintext. When Terraform deploys these resources, it encrypts the specified environment variables using the specified KMS key. 


```
resource "aws_lambda_function" "my_lambda_function" {
  function_name    = "my-lambda-function"
  handler          = "index.handler"
  runtime          = "nodejs14.x"
  role             = aws_iam_role.lambda_role.arn
  filename         = "path/to/lambda_function.zip"
  kms_key_arn      = "arn:aws:signer:us-west-2:123456789012"
}
```

In this configuration:

- `kms_key_arn` specifies the ARN of the aws_kms_key created in AWS Console.

You need to make sure that the *kms_key_arn* attribute is provided a valid string value in the *aws_lambda_function* resource block. If you do, the Policy will give you passing checks else failing checks.

In order to test this policy, use the following commands:

1. Navigate to the `aws/lambda/terraform/check-env-var-encryption` directory. All the payloads along with Terraform files are present in the `test` directory.

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
   kyverno-json scan --payload good-payload.json --policy check-env-var-encryption.yaml
   ```
   Since you have provided a valid string value to the *kms_key_arn* attribute in the *aws_lambda_function* resource block, the policy will give you passing checks. If you would have specifed an empty string or might have not used the attribute, the Policy will give you failing checks. 

   In order to test the policy for bad payload, run the following command:
   ```
   kyverno-json scan --payload bad-payload.json --policy check-env-var-encryption.yaml
   ```