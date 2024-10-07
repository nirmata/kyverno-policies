# Check RDS Instance Copy Tags To Snapshots Enabled

This policy checks whether RDS DB instances are configured to copy all tags to snapshots when the snapshots are created.
Identification and inventory of your IT assets is a crucial aspect of governance and security. 
You need to have visibility of all your RDS DB instances so that you can assess their security posture and take action on 
potential areas of weakness. Snapshots should be tagged in the same way as their parent RDS database instances. 
Enabling this setting ensures that snapshots inherit the tags of their parent database instances.
Read more about it [here](https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-17)

## Policy Details:

- **Policy Name:** check-rds-instance-copy-tags-to-snapshots-enabled
- **Check Description:** This policy checks if RDS DB instances are configured to copy tags to snapshots
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
    kyverno-json scan --payload test/good-test/good-payload-01.json --policy check-rds-instance-copy-tags-to-snapshots-enabled.yaml --bindings test/binding.yaml
    ```

    This produces the output:
    ```bash
    Loading policies ...
    Loading bindings ...
    - analyzer -> map[resource:map[type:terraform-plan]]
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - PASSED (POLICY=check-rds-instance-copy-tags-to-snapshots-enabled, RULE=check-rds-instance-copy-tags-to-snapshots-enabled)
    Done
    ```

    b. **Test Against Invalid Payload:**
    ```
    kyverno-json scan --payload test/bad-test/bad-payload-01.json --policy check-rds-instance-copy-tags-to-snapshots-enabled.yaml --bindings test/binding.yaml
    ```

    This produces the output:
    ```bash
    Loading policies ...
    Loading bindings ...
    - analyzer -> map[resource:map[type:terraform-plan]]
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - FAILED (POLICY=check-rds-instance-copy-tags-to-snapshots-enabled, RULE=check-rds-instance-copy-tags-to-snapshots-enabled)
    -> RDS DB instances should be configured to copy tags to snapshots (CHECK=spec.rules[0].assert.all[0])
    -> Invalid value: false: Expected value: true (PATH=~.(planned_values.root_module.resources[?type=='aws_db_instance'])[0].values.copy_tags_to_snapshot)
    Done
    ```

---