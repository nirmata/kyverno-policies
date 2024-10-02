# Check Lambda VPC

By default, Lambda functions run in a Lambda-managed VPC that has internet access. To access resources in a VPC in your account, you can add a VPC configuration to a function. This restricts the function to resources within that VPC, unless the VPC has internet access. Running Lambda functions within a VPC provides better isolation and control over network access.

## Policy Details:

- **Policy Name:** check-lambda-vpc
- **Check Description:** This policy validates whether vpc_config is specified for the Lambda function.
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
    kyverno-json scan --payload test/good-test/good-payload-01.json --policy check-lambda-vpc.yaml 
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - check-lambda-vpc / check-lambda-vpc /  PASSED
    Done
    ```

    b. **Test Against Invalid Payload:**
    ```
    kyverno-json scan --payload test/bad-test/bad-payload-01.json --policy check-lambda-vpc.yaml 
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - check-lambda-vpc / check-lambda-vpc /  FAILED
    -> 'vpc_config' must be present for the Lambda function
    -> all[0].check.~.(planned_values.root_module.resources[?type=='aws_lambda_function'])[0].values.(vpc_config != `[]`): Invalid value: false: Expected value: true
    Done
    ```

---