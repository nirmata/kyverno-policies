# RDS Instance IAM Authentication Enabled

This policy checks whether an RDS DB instance has IAM database authentication enabled. The policy fails if IAM authentication is not configured for RDS DB instances. This policy only evaluates RDS instances with the following engine types: `mysql`, `postgres`, `aurora`, `aurora-mysql`, `aurora-postgresql` and `mariadb`. IAM database authentication allows authentication to database instances with an authentication token instead of a password. traffic to and from the database is encrypted using SSL.

## Policy Details:

- **Policy Name:** rds-instance-iam-authentication-enabled
- **Check Description:** This policy ensures that IAM authentication is configured for RDS instances
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
    kyverno-json scan --payload test/good-test/good-payload-01.json --policy rds-instance-iam-authentication-enabled.yaml --bindings test/binding.yaml
    ```

    This produces the output:
    ```bash
    Loading policies ...
    Loading bindings ...
    - analyzer -> map[resource:map[type:terraform-plan]]
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - PASSED (POLICY=rds-instance-iam-authentication-enabled, RULE=rds-instance-iam-authentication-enabled)
    Done
    ```

    b. **Test Against Invalid Payload:**
    ```
    kyverno-json scan --payload test/bad-test/bad-payload-01.json --policy rds-instance-iam-authentication-enabled.yaml --bindings test/binding.yaml
    ```

    This produces the output:
    ```bash
    Loading policies ...
    Loading bindings ...
    - analyzer -> map[resource:map[type:terraform-plan]]
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - FAILED (POLICY=rds-instance-iam-authentication-enabled, RULE=rds-instance-iam-authentication-enabled)
    -> IAM authentication should be configured for RDS instances (CHECK=spec.rules[0].assert.all[0])
    -> Invalid value: false: Expected value: true (PATH=~.(planned_values.root_module.resources[?type=='aws_db_instance' && contains($engineTypes, values.engine)])[0].values.(!!iam_database_authentication_enabled))
    Done
    ```

    c. **Test against Payload to Be Skipped:**
    ```
    kyverno-json scan --payload test/skip-test/skip-payload-01.json --policy rds-instance-iam-authentication-enabled.yaml --bindings test/binding.yaml
    ```

    This produces the output:
    ```bash
    Loading policies ...
    Loading bindings ...
    - analyzer -> map[resource:map[type:terraform-plan]]
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    Done
    ```

---