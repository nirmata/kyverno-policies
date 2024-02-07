# Validate ECS Task Definition Memory Hard Limit

This policy checks if Amazon Elastic Container Service (ECS) task definitions have a set memory limit for its container definitions.

## Policy Details:

- **Policy Name:** validate-ecs-task-definition-memory-hard-limit
- **Check Description:** This policy ensures that ECS task definitions has a memory limit set
- **Policy Category:** AWS ECS Best Practices

## How It Works:

### Validation Criteria:

**Key** : memory
**Type** : int
**Required** : No

- **Condition:** `memory` is present
  - **Result:** PASS
  - **Reason:** Memory limit is set

- **Condition:** `memory` is absent
  - **Result:** FAIL
  - **Reason:** Memory limit is not set

### Policy Validation Testing Instructions

To evaluate and test the policy ensuring ECS task definitions meet security standards:

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
    ```bash
    kyverno-json scan --payload payload.json --policy policy.yaml
    ```
    
    a. **Test Policy Against Valid Payload:**
    ```bash
    kyverno-json scan --policy validate-ecs-task-definition-memory-hard-limit.yaml --payload test/good-payload.json
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - validate-ecs-task-definition-memory-hard-limit / validate-ecs-task-definition-memory-hard-limit /  PASSED
    Done
    ```

    b. **Test Against Invalid Payload:**
    ```bash
    kyverno-json scan --policy validate-ecs-task-definition-memory-hard-limit.yaml --payload test/bad-payload.json
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - validate-ecs-task-definition-memory-hard-limit / validate-ecs-task-definition-memory-hard-limit /  FAILED: Please set memory limit for container definitions.: all[0].check.(configuration.root_module.module_calls.ecs_container_definition.expressions).(!memory): Invalid value: true: Expected value: false
    Done
    ```

---

This way you can ensure that your ECS task definitions adhere to security standards regarding memory limits.
