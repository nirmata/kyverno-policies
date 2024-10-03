# Check Control Plane Logging for Amazon EKS

Enabling Amazon EKS control plane logging for all log types is a best practice for enhancing the security, monitoring, troubleshooting, performance optimization, and operational management of your Kubernetes clusters. By capturing comprehensive logs of control plane activities, you can effectively manage and secure your EKS infrastructure while ensuring compliance with regulatory requirements and industry standards.

To enable control plane logging for all types in Amazon EKS, ensure that **enabled_cluster_log_types** includes all these types: "api", "audit", "authenticator", "controllerManager" and "scheduler". You can read more about the log types [here](https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html)

## Policy Details:

- **Policy Name:** check-control-plane-logging
- **Check Description:** Ensure Amazon EKS control plane logging is enabled for all log types
- **Policy Category:** EKS Best Practices 

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
    nctl scan terraform --resources test/good.tf --policies check-control-plane-logging.yaml --details 
    ```

    This produces the output:
    ```
    Version: v4.2.2
    Fetching policies...
    Loading policies...
    - found 1 policies
    Running analysis...
    • no errors
    Results...
    +--------------------+------+------+------+-------+------+
    |      CATEGORY      | FAIL | WARN | PASS | ERROR | SKIP |
    +--------------------+------+------+------+-------+------+
    | EKS Best Practices |  0   |  0   |  1   |   0   |  0   |
    +--------------------+------+------+------+-------+------+
    Rule Results                        : (Fail: 0, Warn: 0, Pass: 1, Error: 0, Skip: 0)
    Failed Rules Severity               : (Critical: 0, High: 0, Medium: 0, Low: 0, Info: 0)

    +-----------------------------+-----------------------------+--------------+---------+--------+
    |           POLICY            |            RULE             |   RESOURCE   | MESSAGE | RESULT |
    +-----------------------------+-----------------------------+--------------+---------+--------+
    | check-control-plane-logging | check-control-plane-logging | test/good.tf |         |  pass  |
    +-----------------------------+-----------------------------+--------------+---------+--------+
    Done!
    ```

    b. **Test Against Invalid Terraform Config File:**
    ```
    nctl scan terraform --resources test/bad-01.tf --policies check-control-plane-logging.yaml --details 
    ```

    This produces the output:
    ```
    Version: v4.2.2
    Fetching policies...
    Loading policies...
    - found 1 policies
    Running analysis...
    • no errors
    Results...
    +--------------------+------+------+------+-------+------+
    |      CATEGORY      | FAIL | WARN | PASS | ERROR | SKIP |
    +--------------------+------+------+------+-------+------+
    | EKS Best Practices |  1   |  0   |  0   |   0   |  0   |
    +--------------------+------+------+------+-------+------+
    Rule Results                        : (Fail: 1, Warn: 0, Pass: 0, Error: 0, Skip: 0)
    Failed Rules Severity               : (Critical: 0, High: 0, Medium: 1, Low: 0, Info: 0)

    +-----------------------------+-----------------------------+----------------+--------------------------------+--------+
    |           POLICY            |            RULE             |    RESOURCE    |            MESSAGE             | RESULT |
    +-----------------------------+-----------------------------+----------------+--------------------------------+--------+
    | check-control-plane-logging | check-control-plane-logging | test/bad-01.tf | EKS control plane logging must |  fail  |
    |                             |                             |                |  be enabled for all log types  |        |
    +-----------------------------+-----------------------------+----------------+--------------------------------+--------+
    Done! 1 policy violation(s) detected.
    ```

---
