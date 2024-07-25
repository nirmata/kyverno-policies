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
- Make sure you have `nctl` installed on the machine 

1. **Test the Policy with nctl:**
    ```
    nctl scan terraform --resources tf-config.tf --policy policy.yaml
    ```

    a. **Test Policy Against Valid Terraform Config File:**
    ```
    nctl scan terraform --resources test/good.tf --policies validate-ecs-container-insights-enabled.yaml 
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
    +-----------------------------------------+-----------------------------------------+--------------+---------+--------+
    |                 POLICY                  |                  RULE                   |   RESOURCE   | MESSAGE | RESULT |
    +-----------------------------------------+-----------------------------------------+--------------+---------+--------+
    | validate-ecs-container-insights-enabled | validate-ecs-container-insights-enabled | test/good.tf |         | pass   |
    +-----------------------------------------+-----------------------------------------+--------------+---------+--------+

    Done
    ```

    b. **Test Against Invalid Terraform Config File:**
    ```
    nctl scan terraform --resources test/bad.tf --policies validate-ecs-container-insights-enabled.yaml 
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
    +-----------------------------------------+-----------------------------------------+-------------+---------------------------------------------------------------------+--------+
    |                 POLICY                  |                  RULE                   |  RESOURCE   |                               MESSAGE                               | RESULT |
    +-----------------------------------------+-----------------------------------------+-------------+---------------------------------------------------------------------+--------+
    | validate-ecs-container-insights-enabled | validate-ecs-container-insights-enabled | test/bad.tf | ECS container insights are not enabled:                             | fail   |
    |                                         |                                         |             | all[0].check.~.(resource.aws_ecs_cluster.values(@)[])[0].~.(setting |        |
    |                                         |                                         |             | || `[{}]`)[0].value: Invalid value: "null": Expected value:         |        |
    |                                         |                                         |             | "enabled"                                                           |        |
    +-----------------------------------------+-----------------------------------------+-------------+---------------------------------------------------------------------+--------+

    Done
    ```

---