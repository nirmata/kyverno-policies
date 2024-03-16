# Validate ECS Task Definition User For Host Mode Policy

This policy aims to identify and address unauthorized permissions in your active Amazon Elastic Container Service (Amazon ECS) task definitions that utilize the host network mode. The rule categorizes task definitions with NetworkMode set to host as NON_COMPLIANT under the following conditions: container definitions with privileged set to false or empty and user set to root or empty.

In scenarios where tasks employ the host network mode, it's crucial to avoid running containers with the root user (UID 0) for enhanced security. As a recommended security practice, it is recommended to opt for a non-root user.

## Policy Details:

- **Policy Name:** validate-ecs-task-definition-user-for-host-mode-check
- **Check Description:** This policy makes sure that ECS task definitions avoids using the root user for the host network mode or false privileges.
- **Policy Category:** AWS ECS Best Practices

## How It Works:

### Validation Criteria:

This policy is effective when the network_mode is set to `host` OR privileged is set to `false`. The policy is deemed NON_COMPLIANT if `user` is configured as null, 0, 'xyz:0", "0:xyz", or not set.

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
    kyverno-json scan --payload payload.json --policy validate-ecs-task-definition-user-for-host-mode-check.yaml
    ```
    
    a. **Test Policy Against Valid Payload:**
    ```bash
    kyverno-json scan --policy validate-ecs-task-definition-user-for-host-mode-check.yaml --payload test/good-payload.json
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - validate-ecs-task-definition-user-for-host-mode-check / validate-ecs-task-definition-user-for-host-mode-check /  PASSED
    Done
    ```

    b. **Test Against Invalid Payload:**
    ```bash
    kyverno-json scan --policy validate-ecs-task-definition-user-for-host-mode-check.yaml --payload test/bad-payload.json
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - validate-ecs-task-definition-user-for-host-mode-check / validate-ecs-task-definition-user-for-host-mode-check /  FAILED: Please set user to non-root user for host network mode or false privileges.: all[0].check.~.(planned_values.root_module.resources[?type=='aws_ecs_task_definition'] )[0].values.~.(json_parse(container_definitions))[0].(starts_with(user || '', '0:') || ends_with(user || '', ':0')): Invalid value: true: Expected value: false
    Done
    ```

---

This way you can ensure that your ECS task definitions adhere to security standards regarding user's root access.

