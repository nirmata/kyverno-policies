# Check RDS Aurora Mysql Audit Logging Enabled

This policy checks whether an Amazon Aurora MySQL DB cluster is configured to publish audit logs to Amazon CloudWatch Logs. 
The policy fails if the cluster isn't configured to publish audit logs to CloudWatch Logs. The policy doesn't generate findings foAurora Serverless v1 DB clusters. Audit logs capture a record of database activity, including login attempts, data modifications, schema changes, and other events that can be audited for security and compliance purposes. 
When you configure an Aurora MySQL DB cluster to publish audit logs to a log group in Amazon CloudWatch Logs, you can perform real-time analysis of the log data. 
CloudWatch Logs retains logs in highly durable storage. You can also create alarms and view metrics in CloudWatch.

## Policy Details:

- **Policy Name:** check-rds-aurora-mysql-audit-logging-enabled
- **Check Description:** This policy checks whether Aurora MySQL DB clusters publish audit logs to CloudWatch Logs
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
    kyverno-json scan --payload test/good-test/good-payload-01.json --policy check-rds-aurora-mysql-audit-logging-enabled.yaml --bindings test/binding.yaml
    ```

    This produces the output:
    ```bash
    Loading policies ...
    Loading bindings ...
    - analyzer -> map[resource:map[type:terraform-plan]]
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - PASSED (POLICY=check-rds-aurora-mysql-audit-logging-enabled, RULE=check-rds-aurora-mysql-audit-logging-enabled)
    Done
    ```

    b. **Test Against Invalid Payload:**
    ```
    kyverno-json scan --payload test/bad-test/bad-payload-01.json --policy check-rds-aurora-mysql-audit-logging-enabled.yaml --bindings test/binding.yaml
    ```

    This produces the output:
    ```bash
    Loading policies ...
    Loading bindings ...
    - analyzer -> map[resource:map[type:terraform-plan]]
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - FAILED (POLICY=check-rds-aurora-mysql-audit-logging-enabled, RULE=check-rds-aurora-mysql-audit-logging-enabled)
    -> Aurora MySQL DB clusters should publish audit logs to CloudWatch Logs (CHECK=spec.rules[0].assert.all[0])
    -> Invalid value: false: Expected value: true (PATH=~.(planned_values.root_module.resources[?type=='aws_rds_cluster' && contains('aurora-mysql', values.engine) && !contains('serverless', values.engine_mode)])[0].values.(enabled_cloudwatch_logs_exports != `null` && length(enabled_cloudwatch_logs_exports) > `0`))
    Done
    ```

---