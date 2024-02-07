# Validate ECS Task Public IP

A public IP address is an IP address that is reachable from the internet. If you launch your Amazon ECS instances with a public IP address, then your Amazon ECS instances are reachable from the internet. Amazon ECS services should not be publicly accessible, as this may allow unintended access to your container application servers.

## Policy Details:

- **Policy Name:** validate-ecs-task-public-ip
- **Check Description:** ECS tasks with public IP address enabled, are easily reachable from the internet. This policy validates whether public IP address is enabled on the ECS task.
- **Policy Category:** AWS ECS Best Practices

## How It Works:

### Validation Criteria:

**Key** : assign_public_ip
**Valid Values** : true | false | not set
**Type** : string
**Required** : No

- **Condition:** `assign_public_ip` is set to `false`
  - **Result:** PASS
  - **Reason:** 


- **Condition:** `assign_public_ip` is not present
  - **Result:** PASS
  - **Reason:** 

- - **Condition:** `network_configuration` is not present
  - **Result:** PASS
  - **Reason:** 

- **Condition:** `assign_public_ip` is set to `true`
  - **Result:** FAIL
  - **Reason:** 

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
    kyverno-json scan --policy validate-ecs-task-public-ip.yaml --payload test/good-payload.json
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - validate-ecs-task-public-ip / validate-ecs-task-public-ip /  PASSED
    Done
    ```

    b. **Test Against Invalid Payload:**
    ```bash
    kyverno-json scan --policy validate-ecs-task-public-ip.yaml --payload test/bad-payload.json
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - validate-ecs-task-public-ip / validate-ecs-task-public-ip /  FAILED: Public IP address is enabled on the ECS task: any[0].check.~.(planned_values.root_module.resources[?type=='aws_ecs_service'])[0].values.~.(network_configuration[?assign_public_ip] || `[]`)[0].assign_public_ip: Invalid value: true: Expected value: false
    Done
    ```

---
