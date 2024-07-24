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

For testing this policy you will need to:
- Make sure you have `nctl` installed on the machine 

1. **Test the Policy with nctl:**
    ```
    nctl scan terraform --resources tf-config.tf --policy policy.yaml
    ```

    a. **Test Policy Against Valid Terraform Config File:**
    ```
    nctl scan terraform --resources test/good.tf --policies validate-ecs-task-public-ip.yaml 
    ```

    This produces the output:
    ```
    Version: 4.0.1
    Fetching policies...
    Loading policies...
    • found 1 policies
    Running analysis...
    • no errors
    Results...
    +-----------------------------+-----------------------------+--------------+---------+--------+
    |           POLICY            |            RULE             |   RESOURCE   | MESSAGE | RESULT |
    +-----------------------------+-----------------------------+--------------+---------+--------+
    | validate-ecs-task-public-ip | validate-ecs-task-public-ip | test/good.tf |         | pass   |
    +-----------------------------+-----------------------------+--------------+---------+--------+

    Done
    ```

    b. **Test Against Invalid Terraform Config File:**
    ```
    nctl scan terraform --resources test/bad.tf --policies validate-ecs-task-public-ip.yaml 
    ```

    This produces the output:
    ```
    Version: 4.0.1
    Fetching policies...
    Loading policies...
    • found 1 policies
    Running analysis...
    • no errors
    Results...
    +-----------------------------+-----------------------------+-------------+------------------------------------------------------------------------------------------------------+--------+
    |           POLICY            |            RULE             |  RESOURCE   |                                               MESSAGE                                                | RESULT |
    +-----------------------------+-----------------------------+-------------+------------------------------------------------------------------------------------------------------+--------+
    | validate-ecs-task-public-ip | validate-ecs-task-public-ip | test/bad.tf | Public IP address should not be enabled:                                                             | fail   |
    |                             |                             |             | any[0].check.~.(resource.aws_ecs_service.values(@)[])[0].~.(network_configuration[?assign_public_ip] |        |
    |                             |                             |             | || `[]`)[0].assign_public_ip: Invalid value: true: Expected value: false                             |        |
    +-----------------------------+-----------------------------+-------------+------------------------------------------------------------------------------------------------------+--------+

    Done
    ```

---
