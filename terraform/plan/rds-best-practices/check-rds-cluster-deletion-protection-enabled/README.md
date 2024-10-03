# Check RDS Cluster Deletion Protection Enabled

Preventing accidental deletion of an RDS database through the AWS Management Console, AWS CLI, or the RDS API is essential for avoiding data loss. 
The database can't be deleted when deletion protection is enabled. This ensures an extra layer of protection for your data, preventing 
unintended actions from impacting availability or causing data loss. By enabling deletion protection, you ensure that the database 
remains intact until deliberate action is taken to disable this setting.

## Policy Details:

- **Policy Name:** check-rds-cluster-deletion-protection-enabled
- **Check Description:** This policy ensures that deletion protection is enabled for RDS databases
- **Policy Category:** AWS RDS Best Practices

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
    ```bash
    kyverno-json scan --payload payload.json --policy policy.yaml
    ```

    a. **Test Policy Against Valid Payload:**
    ```bash
    kyverno-json scan --payload test/good-test/good-payload-01.json --policy check-rds-cluster-deletion-protection-enabled.yaml --bindings test/binding.yaml
    ```

    This produces the output:
    ```bash
    Loading policies ...
    Loading bindings ...
    - analyzer -> map[resource:map[type:terraform-plan]]
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - PASSED (POLICY=check-rds-cluster-deletion-protection-enabled, RULE=check-rds-cluster-deletion-protection-enabled)
    Done
    ```

    b. **Test Against Invalid Payload:**
    ```
    kyverno-json scan --payload test/bad-test/bad-payload-01.json --policy check-rds-cluster-deletion-protection-enabled.yaml --bindings test/binding.yaml
    ```

    This produces the output:
    ```bash
    Loading policies ...
    Loading bindings ...
    - analyzer -> map[resource:map[type:terraform-plan]]
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - FAILED (POLICY=check-rds-cluster-deletion-protection-enabled, RULE=check-rds-cluster-deletion-protection-enabled)
    -> RDS Database Deletion Protection must be enabled (CHECK=spec.rules[0].assert.all[0])
    -> Invalid value: false: Expected value: true (PATH=~.(planned_values.root_module.resources[?type=='aws_rds_cluster'])[0].values.(!!deletion_protection))
    Done
    ```

---