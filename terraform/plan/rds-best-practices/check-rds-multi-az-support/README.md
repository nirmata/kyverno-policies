# Check RDS Multi AZ Support

This policy checks whether high availability is enabled for your RDS DB instances.
RDS DB instances should be configured for multiple Availability Zones (AZs). 
This ensures the availability of the data stored. Multi-AZ deployments allow for automated failover 
if there is an issue with AZ availability and during regular RDS maintenance.
You can read more about it [here](https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-5)

## Policy Details:

- **Policy Name:** check-rds-multi-az-support
- **Check Description:** This policy ensures that RDS DB instances have Multi AZ enabled
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
    kyverno-json scan --payload test/good-test/good-payload-01.json --policy check-rds-multi-az-support.yaml --bindings test/binding.yaml
    ```

    This produces the output:
    ```bash
    Loading policies ...
    Loading bindings ...
    - analyzer -> map[resource:map[type:terraform-plan]]
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - PASSED (POLICY=check-rds-multi-az-support, RULE=check-rds-multi-az-support)
    Done
    ```

    b. **Test Against Invalid Payload:**
    ```
    kyverno-json scan --payload test/bad-test/bad-payload-01.json --policy check-rds-multi-az-support.yaml --bindings test/binding.yaml
    ```

    This produces the output:
    ```bash
    Loading policies ...
    Loading bindings ...
    - analyzer -> map[resource:map[type:terraform-plan]]
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - FAILED (POLICY=check-rds-multi-az-support, RULE=check-rds-multi-az-support)
    -> RDS DB instances should be configured with multiple Availability Zones (CHECK=spec.rules[0].assert.all[0])
    -> Invalid value: false: Expected value: true (PATH=~.(planned_values.root_module.resources[?type=='aws_db_instance'])[0].values.(!!multi_az))
    Done
    ```

---