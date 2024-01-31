# Validate ECS Container Insights Policy

Container Insights plays a crucial role in AWS ECS by providing diagnostic information, including details about container restart failures, aiding in the quick identification and resolution of issues. This policy, "validate-ecs-container-insights-enabled," ensures that ECS clusters have Container Insights enabled for effective monitoring and issue isolation.

## Policy Details:

- **Policy Name:** validate-ecs-container-insights-enabled
- **Check Description:** Verify if ECS clusters have Container Insights enabled.

## Why it Matters:

Container Insights enhances the operational visibility of ECS clusters, allowing for proactive issue resolution. Enabling this feature ensures that diagnostic information is readily available, contributing to a more efficient and reliable containerized environment.

## How It Works:

The policy checks the ECS clusters to confirm whether Container Insights are enabled. If Container Insights are not set up for a cluster, the policy marks it as non-compliant.

### Validation Criteria:

- **Condition:** `containerInsights` is set to `enabled`
  - **Result:** PASS

- **Condition:** `containerInsights` is set to `disabled`
  - **Result:** FAIL

- **Condition:** `containerInsights` is not present
  - **Result:** FAIL

### Policy Validation Testing Instructions

To evaluate and test the policy, follow the steps outlined below:

For testing this policy you will need to:
- Make sure you have `kyverno-json` installed on the machine 
- Properly authenticate with AWS

1. **Initialize Terraform:**
    ```
    terraform init
    ```

2. **Create Binary Terraform Plan:**
    ```
    terraform plan -out tfplan.binary
    ```

3. **Convert Binary to JSON Payload:**
    ```
    terraform show -json tfplan.binary | jq > payload.json
    ```

4. **Test the Policy with Kyverno:**
    ```
   kyverno-json scan --payload payload.json --policy policy.yaml
    ```

    a. **Test Policy Against Valid Payload:**
    ```
    kyverno-json scan --policy validate-ecs-container-insights-enabled.yaml --payload policy-test/good-payload.json
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - validate-ecs-container-insights-enabled / container-insights /  PASSED
    Done
    ```

    b. **Test Against Invalid Payload:**
    ```
    kyverno-json scan --policy validate-ecs-container-insights-enabled.yaml --payload policy-test/bad-payload.json
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - validate-ecs-container-insights-enabled / container-insights /  FAILED: ECS container insights are not enabled: [all[0].check.~.(planned_values.root_module.resources[?type == 'aws_ecs_cluster'])[0].values.(length(setting[?name=='containerInsights'] || `[]`) > `0`): Invalid value: false: Expected value: true, all[0].check.~.(planned_values.root_module.resources[?type == 'aws_ecs_cluster'])[0].values.(!setting): Invalid value: true: Expected value: false]
    Done
    ```

---

By enforcing this policy, you ensure that ECS clusters adhere to best practices in containerized environments by leveraging the capabilities of Container Insights for effective monitoring and issue resolution.
