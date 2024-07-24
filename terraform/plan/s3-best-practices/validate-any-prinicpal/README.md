The principal can be an AWS account, an IAM (Identity and Access Management) user, a federated user, an EC2 instance, or even an AWS service.

When you create a bucket policy for an S3 bucket, you define statements that specify the actions allowed or denied for a given principal. Here's a breakdown of the components in a bucket policy statement related to the principal:

1. **Effect:** It specifies whether the statement allows or denies the specified actions. It can be either "Allow" or "Deny."

2. **Principal:** This is where you specify the entity (AWS account, IAM user, federated user, etc.) to which the policy applies. You can use the wildcard "*" to represent any principal, or you can specify a specific AWS account ID, IAM user ARN (Amazon Resource Name), or other identifiers.

3. **Action:** It defines the specific actions (e.g., "s3:GetObject", "s3:PutObject") that are allowed or denied.

4. **Resource:** It specifies the S3 resources (e.g., bucket names, object keys) to which the policy applies.
   
```
   {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::123456789012:user/example-user"
      },
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::example-bucket"
    }
  ]
}
```
   
In this example:

- Effect: It allows the specified actions.
- Principal: It specifies the IAM user with the ARN "arn:aws:iam::123456789012:user/example-user."
- Action: It allows the "s3:ListBucket" action.
- Resource: It specifies the S3 bucket with the ARN "arn:aws:s3:::example-bucket."

This Policy ensures that the Principal value in the AWS S3 Bucket Policy is not set to `*`. If the Principal value is set to `*`, the policy will give you failing checks.

In order to test this policy, use the following commands:

1. Initialise Terraform in your working directory
    ```
    terraform init
    ```

2. Create a binary of your terraform plan
    ```
    terraform plan -out tfplan.binary
    ```

3. Convert the executable binary into JSON Payload
   ```
   terraform show -json tfplan.binary | jq > payload.json
   ```

4. Test the policy using `kyverno-json scan` command
   ```
   kyverno-json scan --payload payload.json --policy validate-any-principal.yaml --bindings ./binding.yaml 
   ```
In order to run the policy for the failing checks, run it against the *bad-payload.json* present in the *test* folder.
