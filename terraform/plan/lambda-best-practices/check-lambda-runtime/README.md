AWS Lambda runtimes are environments in which your Lambda functions execute. They provide the execution environment, including the language runtime, libraries, and dependencies that your function code needs to run. Each runtime is tailored to support a specific programming language, such as Python, Node.js, Java, or C#. AWS Lambda supports a variety of runtimes to accommodate different programming languages and frameworks.

You can find more information about it [here](https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html)

In order to test this policy, you need set the runtime value in the *aws_lambda_function* block to some value that is not deprecated. If the value is not deprecated, the policy will return you passing checks else failing checks.

```
resource "aws_lambda_function" "terraform_lambda_func" {
filename                       = "${path.module}/python/hello-python.zip"
function_name                  = "Spacelift_Test_Lambda_Function"
role                           = aws_iam_role.lambda_role.arn
handler                        = "index.lambda_handler"
runtime                        = "python2.7"
depends_on                     = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
}
```

1. Navigate to the `aws/lambda/terraform/check-lambda-runtime` directory. All the payloads along with Terraform files are present in the `test` directory.

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
   kyverno-json scan --payload good-payload.json --policy check-url-auth-type.yaml
   ```
   Since you're not using any deprecated runtime for the aws lambda function, the policy will give you passing checks. Run the same command against the bad-paylod present in the *bad-test* directory and you'll get failing checks. This can be done something like:
   ```
   kyverno-json scan --payload bad-payload.json --policy check-x-ray-tracing-enabled.yaml
   ```