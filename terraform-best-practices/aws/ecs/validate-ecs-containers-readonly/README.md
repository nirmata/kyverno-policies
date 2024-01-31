# Validate ECS Containers Readonly Policy

When managing containers within AWS ECS, it's crucial to enforce security measures to prevent unauthorized modifications. One significant aspect is restricting write access to the containers' root filesystems. To achieve this, AWS ECS provides a parameter called `readonlyRootFilesystem` in the container definition. This parameter, when set to `false`, allows write access, and when set to `true`, ensures read-only access. The default value of `readonlyRootFilesystem` is `true`.

Our policy, named "validate-ecs-containers-readonly," ensures that ECS containers follow best practices by having read-only access to their root filesystems.

## Policy Details:

- **Policy Name:** validate-ecs-containers-readonly
- **Check Description:** Ensure ECS containers are limited to read-only access to root filesystems.

## How It Works:

The policy checks if the ECS task definition's container definitions have the `readonlyRootFilesystem` parameter set to `false`. If this parameter is not present or set to `false`, the policy marks the configuration as non-compliant. On the other hand, if the parameter is set to `true` or if the information is not available, the policy considers the configuration compliant. 

### Policy Validation Testing Instructions

To evaluate and test the policy, follow the steps outlined below:

For testing this policy you will need to:
- Make sure you have `kyverno-json` installed on the machine 
- Properly authenticate with AWS

1. **Initialize Terraform:**
    ```
    terraform init
    ```

2. **Create Binary Terraform Plan:**
    ```
    terraform plan -out tfplan.binary
    ```

3. **Convert Binary to JSON Payload:**
    ```
    terraform show -json tfplan.binary | jq > payload.json
    ```

4. **Test the Policy with Kyverno:**
    ```
   kyverno-json scan --payload payload.json --policy policy.yaml
    ```
    
    a. **Test Policy Against Valid Payload:**
    ```
    kyverno-json scan --policy validate-ecs-containers-readonly.yaml --payload policy-test/good-payload.json
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - validate-ecs-containers-readonly / validate-ecs-containers-readonly /  PASSED
    Done
    ```

    b. **Test Against Invalid Payload:**
    ```
    kyverno-json scan --policy validate-ecs-containers-readonly.yaml --payload policy-test/bad-payload.json
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - validate-ecs-containers-readonly / validate-ecs-containers-readonly /  FAILED: any[0].check.(configuration.root_module.module_calls.ecs_container_definition.expressions.readonly_root_filesystem == null): Invalid value: false: Expected value: true; ECS Containers should have read-only access to its root filesystems: any[1].check.configuration.root_module.module_calls.ecs_container_definition.expressions.readonly_root_filesystem.constant_value: Invalid value: false: Expected value: true
    Done
    ```

---

By following these instructions, you can systematically validate and enforce read-only access to ECS containers' root filesystems, aligning your infrastructure with security best practices.