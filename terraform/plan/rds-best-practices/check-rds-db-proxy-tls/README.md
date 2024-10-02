# Check RDS DB Proxy TLS

RDS Proxy can use security mechanisms such as TLS to add an additional layer of security between client applications and the underlying database. 
Database connections often involve sensitive information, such as personally identifiable information (PII), financial data, or confidential business data. 
Protecting this data in transit is important to maintain security of the data.
This policy checks if the RDS Proxy is using TLS.

## Policy Details:

- **Policy Name:** check-rds-db-proxy-tls
- **Check Description:** This policy ensures that RDS Proxies use TLS
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
    kyverno-json scan --payload test/good-test/good-payload-01.json --policy check-rds-db-proxy-tls.yaml --bindings test/binding.yaml
    ```

    This produces the output:
    ```bash
    Loading policies ...
    Loading bindings ...
    - analyzer -> map[resource:map[type:terraform-plan]]
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - PASSED (POLICY=check-rds-db-proxy-tls, RULE=check-rds-db-proxy-tls)
    Done
    ```

    b. **Test Against Invalid Payload:**
    ```
    kyverno-json scan --payload test/bad-test/bad-payload-01.json --policy check-rds-db-proxy-tls.yaml --bindings test/binding.yaml
    ```

    This produces the output:
    ```bash
    Loading policies ...
    Loading bindings ...
    - analyzer -> map[resource:map[type:terraform-plan]]
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - FAILED (POLICY=check-rds-db-proxy-tls, RULE=check-rds-db-proxy-tls)
    -> RDS Database Proxy should use TLS (CHECK=spec.rules[0].assert.all[0])
    -> Invalid value: false: Expected value: true (PATH=~.(planned_values.root_module.resources[?type=='aws_db_proxy'])[0].values.(!!require_tls))
    Done
    ```

---