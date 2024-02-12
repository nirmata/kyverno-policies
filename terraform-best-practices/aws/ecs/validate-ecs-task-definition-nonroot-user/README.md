# Validate ECS Task Definition Non Root User

This policy checks if ECSTaskDefinitions specify a user for Amazon Elastic Container Service (Amazon ECS) EC2 launch type containers to run on. The rule fails if the ‘user’ parameter is not present or set to ‘root’.

## Policy Details:

- **Policy Name:** validate-ecs-task-definition-nonroot-user
- **Check Description:**  For ECS EC2 containers, `user` parameter should not be set to `root`
- **Policy Category:** AWS ECS Best Practices

## How It Works:

### Validation Criteria:

This policy is effective when ECS Task definitions with EC2 launch type is used. `user` parameter should not be set to `root`

**Key:** user
**Valid Values:** null | "0" | "xyz:0" | "0:xyz" | "xyz" | not set
**Type:** string
**Required:** No

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
    kyverno-json scan --policy validate-ecs-task-definition-nonroot-user.yaml --payload test/good-payload.json
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - validate-ecs-task-definition-nonroot-user / validate-ecs-task-definition-nonroot-user /  PASSED
    Done
    ```

    b. **Test Against Invalid Payload:**
    ```bash
    kyverno-json scan --policy validate-ecs-task-definition-nonroot-user.yaml --payload test/bad-payload.json
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - validate-ecs-task-definition-nonroot-user / validate-ecs-task-definition-nonroot-user /  FAILED: Please set user to non-root user for host network mode or false privileges.: all[0].check.~.(planned_values.root_module.resources[?type=='aws_ecs_task_definition'])[0].values.~.(json_parse(container_definitions))[0].(starts_with(user || '', '0:') || ends_with(user || '', ':0')): Invalid value: true: Expected value: false
    Done
    ```

---

