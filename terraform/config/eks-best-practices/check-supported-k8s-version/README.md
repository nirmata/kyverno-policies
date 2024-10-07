# Check Supported AWS EKS K8s Version

Kubernetes rapidly evolves with new features, design updates, and bug fixes. The community releases new Kubernetes minor versions (such as 1.30) on average once every four months. Amazon EKS follows the upstream release and deprecation cycle for minor versions. As new Kubernetes versions become available in Amazon EKS, it is recommended to proactively update your clusters to use the latest available version.

You can read more about it [here](https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html)

## Policy Details:

- **Policy Name:** check-supported-k8s-version
- **Check Description:** Check Supported K8s Version in AWS EKS
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
    nctl scan terraform --resources test/good-01.tf --policies check-supported-k8s-version.yaml --details
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

    +-----------------------------+-----------------------------+-----------------+---------+--------+
    |           POLICY            |            RULE             |    RESOURCE     | MESSAGE | RESULT |
    +-----------------------------+-----------------------------+-----------------+---------+--------+
    | check-supported-k8s-version | check-supported-k8s-version | test/good-01.tf |         |  pass  |
    +-----------------------------+-----------------------------+-----------------+---------+--------+
    Done!
    ```

    b. **Test Against Invalid Terraform Config File:**
    ```
    nctl scan terraform --resources test/bad.tf --policies check-supported-k8s-version.yaml --details 
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

    +-----------------------------+-----------------------------+-------------+--------------------------------+--------+
    |           POLICY            |            RULE             |  RESOURCE   |            MESSAGE             | RESULT |
    +-----------------------------+-----------------------------+-------------+--------------------------------+--------+
    | check-supported-k8s-version | check-supported-k8s-version | test/bad.tf | Version specified must be one  |  fail  |
    |                             |                             |             |  of these suppported versions  |        |
    |                             |                             |             |    ['1.23', '1.24', '1.25',    |        |
    |                             |                             |             |    '1.26', '1.27', '1.28',     |        |
    |                             |                             |             |        '1.29', '1.30']         |        |
    +-----------------------------+-----------------------------+-------------+--------------------------------+--------+
    Done! 1 policy violation(s) detected.
    ```

---