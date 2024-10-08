# Check RDS Automatic Minor Version Upgrade Enabled

This policy checks whether automatic minor version upgrades are enabled for the RDS database instance.
Enabling automatic minor version upgrades ensures that the latest minor version updates to the 
relational database management system (RDBMS) are installed. These upgrades might include security patches and bug fixes. 
Keeping up to date with patch installation is an important step in securing systems.

## Policy Details:

- **Policy Name:** check-rds-automatic-minor-version-upgrade-enabled
- **Check Description:** This policy checks whether automatic minor version upgrades are enabled for the RDS database instance.
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
    kyverno-json scan --payload test/good-test/good-payload-01.json --policy check-rds-automatic-minor-version-upgrade-enabled.yaml --bindings test/binding.yaml
    ```

    This produces the output:
    ```bash
    Loading policies ...
    Loading bindings ...
    - analyzer -> map[resource:map[type:terraform-plan]]
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - PASSED (POLICY=check-rds-automatic-minor-version-upgrade-enabled, RULE=check-rds-automatic-minor-version-upgrade-enabled)
    Done
    ```

    b. **Test Against Invalid Payload:**
    ```bash
    kyverno-json scan --payload test/bad-test/bad-payload-01.json --policy check-rds-automatic-minor-version-upgrade-enabled.yaml --bindings test/binding.yaml
    ```

    This produces the output:
    ```bash
    Loading policies ...
    Loading bindings ...
    - analyzer -> map[resource:map[type:terraform-plan]]
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - FAILED (POLICY=check-rds-automatic-minor-version-upgrade-enabled, RULE=check-rds-automatic-minor-version-upgrade-enabled)
    -> RDS instances should have automatic minor version upgrades enabled (CHECK=spec.rules[0].assert.all[0])
    -> Invalid value: false: Expected value: true (PATH=~.(planned_values.root_module.resources[?type=='aws_db_instance'])[0].values.(auto_minor_version_upgrade))
    Done
    ```

---