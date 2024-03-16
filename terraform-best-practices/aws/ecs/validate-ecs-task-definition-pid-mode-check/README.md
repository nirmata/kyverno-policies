# Validate ECS Task Definition PID Mode Policy

This policy ensures that Amazon ECS task definitions do not share the host's process namespace, aligning with security standards (NIST 800-53 controls CA-9(1) and CM-2). If the host PID mode is used, there's a heightened risk of undesired process namespace exposure.

## Policy Details:

- **Policy Name:** validate-ecs-task-definition-pid-mode-check
- **Check Description:** This policy ensures that ECS task definitions do not share the host's process namespace
- **Policy Category:** AWS ECS Best Practices

## How It Works:

### Validation Criteria:

**Key** : pid_mode
**Valid Values** : host | task | null
**Type** : string
**Required** : No

- **Condition:** `pid_mode` is set to `task`
  - **Result:** PASS
  - **Reason:** If task is specified, all containers within the specified task share the same process namespace.


- **Condition:** `pid_mode` is set to `null`
  - **Result:** PASS
  - **Reason:** If no value is specified, the default is a private namespace for each container.

- **Condition:** `pid_mode` is set to `host`
  - **Result:** FAIL
  - **Reason:** If host is specified, all containers within the tasks that specified the host PID mode on the same container instance share the same process namespace with the host Amazon EC2 instance.

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
    kyverno-json scan --payload payload.json --policy validate-ecs-task-definition-pid-mode-check.yaml
    ```
    
    a. **Test Policy Against Valid Payload:**
    ```bash
    kyverno-json scan --policy validate-ecs-task-definition-pid-mode-check.yaml --payload test/good-payload.json
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - validate-ecs-task-definition-pid-mode-check / validate-ecs-task-definition-pid-mode-check /  PASSED
    Done
    ```

    b. **Test Against Invalid Payload:**
    ```bash
    kyverno-json scan --policy validate-ecs-task-definition-pid-mode-check.yaml --payload test/bad-payload.json
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - validate-ecs-task-definition-pid-mode-check / validate-ecs-task-definition-pid-mode-check /  FAILED: ECS task definitions shares the host's process namespace: all[0].check.~.(planned_values.root_module.resources[?type=='aws_ecs_task_definition'].values)[0].(pid_mode || 'task'): Invalid value: "host": Expected value: "task"
    Done
    ```

---

This way you can ensure that your ECS task definitions adhere to security standards regarding the sharing of the host's process namespace.
