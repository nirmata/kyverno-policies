# Check Source Arn Account

Granting unrestricted access to Lambda functions from other AWS services can compromise the security of your system. To mitigate this risk, it is essential to restrict access by using the `source_arn` or `source_account` parameters. By doing so, you ensure that access is only allowed from specific resources and accounts, respectively, thereby enhancing the security of your applications and data within AWS.

## Policy Details:

- **Policy Name:** check-source-arn-account
- **Check Description:** This policy ensures that AWS Lambda function permissions delegated to AWS services are limited by SourceArn or SourceAccount
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
    kyverno-json scan --payload test/good-test/good-payload-01.json --policy check-source-arn-account.yaml 
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - check-source-arn-account / check-source-arn-account /  PASSED
    Done
    ```

    b. **Test Against Invalid Payload:**
    ```
    kyverno-json scan --payload test/bad-test/bad-payload-01.json --policy check-source-arn-account.yaml 
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - check-source-arn-account / check-source-arn-account /  FAILED
    -> AWS Lambda function permissions delegated to AWS services should be limited by SourceArn or SourceAccount
    -> all[0].check.~.(planned_values.root_module.resources[?type=='aws_lambda_permission'].values[?ends_with(principal, '.amazonaws.com')])[0].(!source_arn == `true` && !source_account == `true`): Invalid value: true: Expected value: false
    Done
    ```

---