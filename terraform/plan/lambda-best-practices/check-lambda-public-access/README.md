# Check Lambda Public Access

Granting public access to AWS Lambda functions is not recommended for security reasons. Restricting public access can help you prevent unauthorized invocations, which could compromise your data or incur unwanted costs.

To restrict access to your Lambda functions, specify the AWS account IDs or the Amazon Resource Names (ARNs) of the IAM users, roles, or services explicitly in the `principal` attribute instead of using `*`. This ensures that only trusted entities can invoke your Lambda functions, enhancing your security posture.

## Policy Details:

- **Policy Name:** check-lambda-public-access
- **Check Description:** This policy ensures that AWS Lambda function is not publicly accessible
- **Policy Category:** AWS Lambda Best Practices

### Policy Validation Testing Instructions

For testing this policy you will need to:
- Make sure you have `kyverno-json` installed on the machine 
- Properly authenticate with AWS

1. **Initialize Terraform:**
    ```bash
    terraform init
    ```

2. **Create Binary Terraform Plan:**
    ```bash
    terraform plan -out tfplan.binary
    ```

3. **Convert Binary to JSON Payload:**
    ```bash
    terraform show -json tfplan.binary | jq > payload.json
    ```

4. **Test the Policy with Kyverno:**
    ```
    kyverno-json scan --payload payload.json --policy policy.yaml
    ```

    a. **Test Policy Against Valid Payload:**
    ```
    kyverno-json scan --payload test/good-test/good-payload-01.json --policy check-lambda-public-access.yaml --bindings test/binding.yaml
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading bindings ...
    - analyzer -> map[resource:map[type:terraform-plan]]
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - PASSED (POLICY=check-lambda-public-access, RULE=check-lambda-public-access)
    Done
    ```

    b. **Test Against Invalid Payload:**
    ```
    kyverno-json scan --payload test/bad-test/bad-payload-01.json --policy check-lambda-public-access.yaml --bindings test/binding.yaml
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading bindings ...
    - analyzer -> map[resource:map[type:terraform-plan]]
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - FAILED (POLICY=check-lambda-public-access, RULE=check-lambda-public-access)
    -> Principal must be set to a specific resource or user account and not '*' (CHECK=spec.rules[0].assert.all[0])
    -> Invalid value: false: Expected value: true (PATH=~.(planned_values.root_module.resources[?type=='aws_lambda_permission'])[0].values.(principal != '*'))
    Done
    ```

---