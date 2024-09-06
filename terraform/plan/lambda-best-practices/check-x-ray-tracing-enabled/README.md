Enabling X-Ray for AWS Lambda empowers developers with comprehensive tracing capabilities, capturing and visualizing the flow of requests through serverless applications. By tracing requests as they traverse Lambda functions and other AWS services, X-Ray provides valuable insights into performance, errors, and dependencies, facilitating efficient debugging and optimization. With detailed analysis and visualization of request paths, developers can identify bottlenecks, troubleshoot issues, and make informed decisions to enhance the reliability and efficiency of their serverless architectures.


To enable X-Ray tracing for an AWS Lambda function using Terraform, you need to include the *tracing_config* block within the aws_lambda_function resource and set its *mode* attribute to "Active" or "PassThrough". However, if you have not specified the *tracing_config* block, the X-Ray tracing will be disabled.

```
resource "aws_lambda_function" "example" {
  function_name = "example_lambda_function"
  handler       = "index.handler"
  runtime       = "nodejs14.x"
  filename      = "lambda_function_payload.zip"
  role          = aws_iam_role.lambda_exec.arn
  source_code_hash = filebase64sha256("lambda_function_payload.zip")

  tracing_config {
    mode = "Active"
  }
}
```

Imagine you have a web application where users can upload images, and you use an API Gateway endpoint to trigger a Lambda function that processes these images. You also have X-Ray enabled for your API Gateway.

Now, let's say a user uploads an image, triggering the Lambda function through the API Gateway. Here's what happens with different tracing modes:

**Active Mode:**

When X-Ray tracing is set to "Active" for the Lambda function, it means X-Ray will always trace requests made to this function, regardless of whether the upstream service (in this case, the API Gateway) has tracing enabled. So, even if the API Gateway didn't have X-Ray tracing enabled, X-Ray would still trace the request as it passes through the Lambda function. You'd be able to see detailed information about the request's path, performance, and any issues encountered within the Lambda function in the X-Ray console.

**PassThrough Mode:**

When X-Ray tracing is set to "PassThrough" for the Lambda function, it means the Lambda function will inherit the tracing settings from the upstream service, in this case, the API Gateway.
If the API Gateway has X-Ray tracing enabled and passes trace headers, the Lambda function will continue tracing the request using the same trace ID. This allows you to follow the entire request path from the API Gateway through to the Lambda function in the X-Ray console. If the API Gateway doesn't have X-Ray tracing enabled or doesn't pass trace headers, the Lambda function will still have X-Ray tracing enabled, but it won't be able to trace the request back to the API Gateway. You'll only see traces within the Lambda function itself.

This policy checks whether you've enabled the X-Ray tracing or not. If the mode is set to *Active* or *PassThrough*, it means the X-Ray tracing is enabled else disabled.

In order to test this policy, use the following commands:

1. Navigate to the `aws/lambda/terraform/check-x-ray-tracing-enabled` directory. All the payloads along with Terraform files are present in the `test` directory.

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
   kyverno-json scan --payload good-payload.json --policy check-x-ray-tracing-enabled.yaml --bindings ./binding.yaml
   ```
   Since you've set the *mode* in the *aws_lambda_function* resource block to *Active*, the policy will give you passing checks. Run the same command against the bad-paylod present in the *bad-test* directory and you'll get failing checks. This can be done something like:
   ```
   kyverno-json scan --payload bad-payload.json --policy check-x-ray-tracing-enabled.yaml --bindings ./binding.yaml
   ```   
