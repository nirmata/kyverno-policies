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
    kyverno-json scan --policy validate-efs-volume-encryption.yaml --payload test/good-payload.json --bindings test/binding.yaml
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading bindings ...
    - analyzer -> map[resource:map[type:terraform-plan]]
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - validate-efs-volume-encryption / validate-efs-volume-encryption /  PASSED
    Done
    ```

    b. **Test Against Invalid Payload:**
    ```bash
    kyverno-json scan --policy validate-efs-volume-encryption.yaml --payload test/bad-payload.json --bindings test/binding.yaml
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading bindings ...
    - analyzer -> map[resource:map[type:terraform-plan]]
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - validate-efs-volume-encryption / validate-efs-volume-encryption /  FAILED
    -> Transit Encryption is not `ENABLED` for EFS volumes in ECS Task definitions
    -> all[0].check.~.(planned_values.root_module.resources[?type=='aws_ecs_task_definition'])[0].~.(values.volume[] || `[]`)[0].~.(efs_volume_configuration[] || `[]`)[0].(transit_encryption == 'ENABLED'): Invalid value: false: Expected value: true
    Done
    ```

---