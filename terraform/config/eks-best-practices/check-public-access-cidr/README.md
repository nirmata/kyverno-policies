# Check Public Access Cidr

When you create a new cluster, Amazon EKS creates an endpoint for the managed Kubernetes API server that you use to communicate with your cluster (using Kubernetes management tools such as kubectl). By default, this API server endpoint receives requests from all (**0.0.0.0/0**) IP addresses. Disallowing access to **0.0.0.0/0** endpoint is a fundamental security measure that helps protect your EKS clusters from unauthorized access, security threats, and compliance violations.

You can read more about it [here](https://docs.aws.amazon.com/eks/latest/userguide/cluster-endpoint.html)

## Policy Details:

- **Policy Name:** check-public-access-cidr
- **Check Description:** Ensuring that the Amazon EKS public endpoint is not accessible to 0.0.0.0/0
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
    nctl scan terraform --resources test/good-01.tf --policies check-public-access-cidr.yaml --details 
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

    +--------------------------+--------------------------+-----------------+---------+--------+
    |          POLICY          |           RULE           |    RESOURCE     | MESSAGE | RESULT |
    +--------------------------+--------------------------+-----------------+---------+--------+
    | check-public-access-cidr | check-public-access-cidr | test/good-01.tf |         |  pass  |
    +--------------------------+--------------------------+-----------------+---------+--------+
    Done!
    ```

    b. **Test Against Invalid Terraform Config File:**
    ```
    nctl scan terraform --resources test/bad-01.tf --policies check-public-access-cidr.yaml --details 
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

    +--------------------------+--------------------------+----------------+--------------------------------+--------+
    |          POLICY          |           RULE           |    RESOURCE    |            MESSAGE             | RESULT |
    +--------------------------+--------------------------+----------------+--------------------------------+--------+
    | check-public-access-cidr | check-public-access-cidr | test/bad-01.tf | Public endpoint should not be  |  fail  |
    |                          |                          |                |    accessible to 0.0.0.0/0     |        |
    +--------------------------+--------------------------+----------------+--------------------------------+--------+
    Done! 1 policy violation(s) detected.
    ```

---