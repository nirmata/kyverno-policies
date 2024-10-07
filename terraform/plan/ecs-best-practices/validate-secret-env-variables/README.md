# Validate Secret Env Variables

Passing sensitive data in plaintext can cause security issues. The data might be discoverable in the AWS Management Console or through AWS APIs such as DescribeTaskDefinition.To securely inject data into containers, reference the values stored in Parameter Store, a capability of AWS Systems Manager. You can also use AWS Secrets Manager in an Amazon ECS task definition. Then, you can expose your sensitive information as environment variables or in the log configuration of a container. This policy checks if any of the environment variables passed are any of AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, or ECS_ENGINE_AUTH_DATA.

## Policy Details:

- **Policy Name:** validate-secret-env-variables
- **Check Description:** This policy ensures any of the environment variables passed are any of AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, or ECS_ENGINE_AUTH_DATA.
- **Policy Category:** AWS ECS Best Practices

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
    kyverno-json scan --policy validate-secret-env-variables.yaml --payload test/good-test/good-payload-01.json --bindings test/binding.yaml
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading bindings ...
    - analyzer -> map[resource:map[type:terraform-plan]]
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - validate-secret-env-variables / validate-secret-env-variables /  PASSED
    Done
    ```
    b. **Test Against Invalid Payload:**
    ```bash
    kyverno-json scan --policy validate-secret-env-variables.yaml --payload test/bad-test/bad-payload-01.json --bindings test/binding.yaml
    ```

    This produces the output:
    ```bash
    Loading policies ...
    Loading bindings ...
    - analyzer -> map[resource:map[type:terraform-plan]]
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - validate-secret-env-variables / validate-secret-env-variables /  FAILED
    -> ECS task definitions should not contain sensitive environment variables like AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, or ECS_ENGINE_AUTH_DATA.
    -> all[0].check.~.(planned_values.root_module.resources[?type=='aws_ecs_task_definition'])[0].values.~.(json_parse(container_definitions))[0].~.(environment || `[]`)[0].name.(!contains(@, 'AWS_ACCESS_KEY_ID')): Invalid value: false: Expected value: true
    Done
    ```
---