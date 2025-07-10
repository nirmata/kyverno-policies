# Check X-Ray Tracing Enabled

Enabling X-Ray for AWS Lambda empowers developers with comprehensive tracing capabilities, capturing and visualizing the flow of requests through serverless applications. By tracing requests as they traverse Lambda functions and other AWS services, X-Ray provides valuable insights into performance, errors, and dependencies, facilitating efficient debugging and optimization. With detailed analysis and visualization of request paths, developers can identify bottlenecks, troubleshoot issues, and make informed decisions to enhance the reliability and efficiency of their serverless architectures.

Imagine you have a web application where users can upload images, and you use an API Gateway endpoint to trigger a Lambda function that processes these images. You also have X-Ray enabled for your API Gateway.

Now, let's say a user uploads an image, triggering the Lambda function through the API Gateway. Here's what happens with different tracing modes:

**Active Mode:**

When X-Ray tracing is set to "Active" for the Lambda function, it means X-Ray will always trace requests made to this function, regardless of whether the upstream service (in this case, the API Gateway) has tracing enabled. So, even if the API Gateway didn't have X-Ray tracing enabled, X-Ray would still trace the request as it passes through the Lambda function. You'd be able to see detailed information about the request's path, performance, and any issues encountered within the Lambda function in the X-Ray console.

**PassThrough Mode:**

When X-Ray tracing is set to "PassThrough" for the Lambda function, it means the Lambda function will inherit the tracing settings from the upstream service, in this case, the API Gateway.
If the API Gateway has X-Ray tracing enabled and passes trace headers, the Lambda function will continue tracing the request using the same trace ID. This allows you to follow the entire request path from the API Gateway through to the Lambda function in the X-Ray console. If the API Gateway doesn't have X-Ray tracing enabled or doesn't pass trace headers, the Lambda function will still have X-Ray tracing enabled, but it won't be able to trace the request back to the API Gateway. You'll only see traces within the Lambda function itself.

## Policy Details:

-   **Policy Name:** Check X-Ray Tracing Enabled
-   **Check Description:** This policy checks whether you've enabled the X-Ray tracing or not. If the mode is set to *Active*, it means the X-Ray tracing is enabled else disabled.

-   **Policy Category:** AWS Lambda Best Practices

## Policy Validation Testing Instructions

For testing this policy you will need to:

-   Make sure you have `cloud-scanner` installed on the machine
-   Properly authenticate with AWS

1. **Set up for the Lambda Function:**

    a. Create a `lambda_function.py` file with the following code:

    ```python
    def lambda_handler(event, context):
        return {
            'statusCode': 200,
            'body': 'Hello, world!'
        }
    ```

    b. Store the above python file in a zip file `lambda-code.zip`
2. **Create an IAM Role for Lambda:**
    ```bash
    aws iam create-role \
    --role-name <RoleName> \
    --assume-role-policy-document '{
        "Version": "2012-10-17",
        "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
            "Service": "lambda.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
        ]
    }'
    ```
3. **Create an IAM Policy for Lambda:**
    ```bash
    aws iam create-policy \
    --policy-name aws_iam_policy_for_terraform_aws_lambda_role \
    --policy-document '{
        "Version": "2012-10-17",
        "Statement": [
        {
            "Action": [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:*",
            "Effect": "Allow"
        }
        ]
    }'
    ```
4. **Attach the Policy to the IAM Role:**
    a. Retrieve the ARN of the created policy:
    ```bash
    aws iam list-policies --query "Policies[?PolicyName=='aws_iam_policy_for_terraform_aws_lambda_role'].Arn" --output text
    ```
    b. Use the ARN to attach the policy to the IAM role:
    ```bash
    aws iam attach-role-policy \
    --role-name Spacelift_Test_Lambda_Function_Role \
    --policy-arn <POLICY_ARN>
    ```
5. **Create Lambda Functions:**
    Good Lambda Function
    ```bash
    aws lambda create-function \
    --function-name GoodLambdaFunction \
    --runtime python3.8 \
    --role arn:aws:iam::<ACCOUNT_ID>:role/<RoleName>> \
    --handler index.lambda_handler \
    --zip-file fileb://lambda_function.zip \
    --tracing-config Mode=Active
    ```

    NOTE - This step will fail if you have applied the policy as a result of Admission Controller.

    Bad Lambda Function
    ```bash
     aws lambda create-function \
     --function-name BadLambdaFunction \
     --runtime python2.7 \
     --role arn:aws:iam::<ACCOUNT_ID>:role/<RoleName>> \
     --handler index.lambda_handler \
     --zip-file fileb://lambda_function.zip
    ```


6. **Get the Payloads:**

    Good Payload
    ```bash
    aws cloudcontrol get-resource  --type-name AWS::Lambda::Function --profile devtest-sso --identifier GoodLambdaFunction | jq '.ResourceDescription.Properties |= fromjson'
    ```
    Bad Payload
    ```bash
    aws cloudcontrol get-resource  --type-name AWS::Lambda::Function --profile devtest-sso --identifier BadLambdaFunction | jq '.ResourceDescription.Properties |= fromjson'
    ```


## Test the Policy with Cloud Scanner:

a. **Apply the Policy after making the appropriate AWS resources:**

```
kubectl apply -f ./check-x-ray-tracing-enabled.yaml
```


b. **Check the Report Generated by Cloud Scanner:**

```
kubectl get clusterpolicyreport
```


```
NAME                                                              KIND             NAME                             PASS   FAIL   WARN   ERROR   SKIP      AGE
65dce8b586794a7ec90e54d03f32a339e1a7cfbfffa115f732d8a78382c3f5f   LambdaFunction   GoodLambdaFunction                 1      0      0      0       0      7m54s
65dce8b586794a7ec90e54d03f32a339e1a7cfbfffa115f732d8a78382c3asd   LambdaFunction   BadLambdaFunction                  0      1      0      0       0      7m54s

```

---