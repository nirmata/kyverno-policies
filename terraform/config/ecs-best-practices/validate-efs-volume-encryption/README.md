# Validate EFS Volume Encryption 

Amazon EFS file systems can be used with Amazon ECS to export file system data across your fleet of container instances. To ensure encryption is enabled in transit, this policy validates whether transit_encryption is set to ENABLED in the task definition.

## Policy Details:

- **Policy Name:** validate-efs-volume-encryption
- **Check Description:** Ensure Transit Encryption is enabled for EFS volumes in ECS Task definitions
- **Policy Category:** AWS ECS Best Practices

## How It Works:

### Validation Criteria:

**Key** : transit_encryption
**Valid Values** : ENABLED | DISABLED
**Type** : string
**Required** : No

- **Condition:** `transit_encryption` is set to `ENABLED`
  - **Result:** PASS
  - **Reason:** Transit Encryption is enabled for EFS volumes in ECS Task definitions


- **Condition:** `transit_encryption` is set to `DISABLED`
  - **Result:** FAIL
  - **Reason:** Transit Encryption is disabled for EFS volumes in ECS Task definitions

- **Condition:** `transit_encryption` is omitted
  - **Result:** FAIL
  - **Reason:**  If `transit_encryption` is omitted, the default value of DISABLED is used.

### Policy Validation Testing Instructions

For testing this policy you will need to:
- Make sure you have `nctl` installed on the machine 

1. **Test the Policy with nctl:**
    ```
    nctl scan terraform --resources tf-config.tf --policy policy.yaml
    ```

    a. **Test Policy Against Valid Terraform Config File:**
    ```
    nctl scan terraform --resources test/good1.tf --policies validate-efs-volume-encryption.yaml 
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
    +--------------------------------+--------------------------------+---------------+---------+--------+
    |             POLICY             |              RULE              |   RESOURCE    | MESSAGE | RESULT |
    +--------------------------------+--------------------------------+---------------+---------+--------+
    | validate-efs-volume-encryption | validate-efs-volume-encryption | test/good1.tf |         | pass   |
    +--------------------------------+--------------------------------+---------------+---------+--------+

    Done
    ```

    b. **Test Against Invalid Terraform Config File:**
    ```
    nctl scan terraform --resources test/bad.tf --policies validate-efs-volume-encryption.yaml 
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
    +--------------------------------+--------------------------------+-------------+----------------------------------------------------------------------------+--------+
    |             POLICY             |              RULE              |  RESOURCE   |                                  MESSAGE                                   | RESULT |
    +--------------------------------+--------------------------------+-------------+----------------------------------------------------------------------------+--------+
    | validate-efs-volume-encryption | validate-efs-volume-encryption | test/bad.tf | Transit Encryption is not `ENABLED` for                                    | fail   |
    |                                |                                |             | EFS volumes in ECS Task definitions:                                       |        |
    |                                |                                |             | all[0].check.~.(resource.aws_ecs_task_definition.values(@)[])[1].~.(volume |        |
    |                                |                                |             | || `[]`)[0].~.(efs_volume_configuration || `[]`)[0].(transit_encryption == |        |
    |                                |                                |             | 'ENABLED'): Invalid value: false: Expected value: true                     |        |
    +--------------------------------+--------------------------------+-------------+----------------------------------------------------------------------------+--------+

    Done
    ```

---