# Check Nodegroup Remote Access

As a general security measure, it's crucial to ensure that your AWS EKS node group does not have implicit SSH access from 0.0.0.0/0, thus not being accessible over the internet. This protects your EKS node group from unauthorized access by external entities.

## Policy Details:

- **Policy Name:** check-nodegroup-remote-access
- **Check Description:** Ensure AWS EKS node group does not have implicit SSH access from 0.0.0.0/0
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
    nctl scan terraform --resources test/good-01.tf --policies check-nodegroup-remote-access.yaml --details
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

    +-------------------------------+-------------------------------+-----------------+---------+--------+
    |            POLICY             |             RULE              |    RESOURCE     | MESSAGE | RESULT |
    +-------------------------------+-------------------------------+-----------------+---------+--------+
    | check-nodegroup-remote-access | check-nodegroup-remote-access | test/good-01.tf |         |  pass  |
    +-------------------------------+-------------------------------+-----------------+---------+--------+
    Done!
    ```

    b. **Test Against Invalid Terraform Config File:**
    ```
    nctl scan terraform --resources test/bad-01.tf --policies check-nodegroup-remote-access.yaml --details
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
    Failed Rules Severity               : (Critical: 0, High: 1, Medium: 0, Low: 0, Info: 0)

    +-------------------------------+-------------------------------+----------------+--------------------------------+--------+
    |            POLICY             |             RULE              |    RESOURCE    |            MESSAGE             | RESULT |
    +-------------------------------+-------------------------------+----------------+--------------------------------+--------+
    | check-nodegroup-remote-access | check-nodegroup-remote-access | test/bad-01.tf | AWS EKS node group should not  |  fail  |
    |                               |                               |                | have implicit SSH access from  |        |
    |                               |                               |                |           0.0.0.0/0            |        |
    +-------------------------------+-------------------------------+----------------+--------------------------------+--------+
    Done! 1 policy violation(s) detected.
    ```

---