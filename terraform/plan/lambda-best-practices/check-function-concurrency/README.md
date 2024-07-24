Concurrency level configuration for an AWS Lambda function refers to the setting that determines how many concurrent executions of the Lambda function are allowed to run simultaneously. In simpler terms, it controls how many instances of your Lambda function can run concurrently in response to incoming events or triggers.

In Terraform, you can configure the concurrency level using the `reserved_concurrent_executions` argument within the aws_lambda_function resource block. This argument accepts a non-negative integer value, including zero, where:

- Setting `reserved_concurrent_executions` to 0 means that no concurrency is reserved for this Lambda function. It allows the Lambda function to scale freely based on demand, subject to account-level concurrency limits.

- Setting `reserved_concurrent_executions` to a positive integer (e.g., 10) reserves a specific concurrency level for the Lambda function. This limits the number of concurrent executions of the function, ensuring that it does not exceed the specified concurrency level, even if there is a sudden spike in incoming events or triggers.

This policy ensures that the concurrency level configuration is set to AWS Lambda function.

To set the concurrency level configuration for an AWS Lambda function using Terraform, you can use the `reserved_concurrent_executions` argument within the `aws_lambda_function` resource block. Here's an example of how you can do it:

```
resource "aws_lambda_function" "example_lambda" {
  function_name    = "example_lambda_function"
  handler          = "index.handler"
  runtime          = "nodejs14.x"
  filename         =  "lambda_function_payload.zip"
  role             = aws_iam_role.lambda_role.arn
  source_code_hash = filebase64sha256("lambda_function_payload.zip")
  reserved_concurrent_executions = 10
}
```

In order to test this policy, use the following commands:

1. Navigate to the `aws/lambda/terraform/check-function-concurrency` directory. All the payloads along with Terraform files are present in the `test` directory.

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
   kyverno-json scan --payload good-payload.json --policy check-function-concurrency.yaml --bindings ./binding.yaml
   ```
   Since you have provided a valid non-negative value to the *reserved_concurrent_executions* attribute in the *aws_lambda_function* resource block, the policy will give you passing checks. If you would have specifed an empty string or might have not used the attribute or provided a non-negative value, the Policy will give you failing checks. 

   In order to test the policy for bad payload, run the following command:
   ```
   kyverno-json scan --payload bad-payload-01.json --policy check-function-concurrency.yaml --bindings ./binding.yaml
   ```