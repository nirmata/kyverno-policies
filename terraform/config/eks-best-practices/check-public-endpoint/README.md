# Check Public Endpoint access to AWS EKS

Disabling the public endpoint minimizes the risk of unauthorized access and potential security breaches by reducing the attack surface of the EKS control plane. 
It protects against external threats and enforces network segmentation, restricting access to only trusted entities within the network environment. 
This measure helps organizations meet compliance requirements, maintains operational security, and safeguards the reliability and performance of Kubernetes clusters.

To disable public access to the control plane, ensure that **endpoint_public_access** is set to *false* explicitly. You can read more about endpoint access control [here](https://docs.aws.amazon.com/eks/latest/userguide/cluster-endpoint.html)
## Policy Details:

- **Policy Name:** check-public-endpoint
- **Check Description:** Ensure public endpoint access to AWS EKS is disabled
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
    nctl scan terraform --resources test/good.tf --policies check-public-endpoint.yaml --details  
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

    +-----------------------+-----------------------+--------------+---------+--------+
    |        POLICY         |         RULE          |   RESOURCE   | MESSAGE | RESULT |
    +-----------------------+-----------------------+--------------+---------+--------+
    | check-public-endpoint | check-public-endpoint | test/good.tf |         |  pass  |
    +-----------------------+-----------------------+--------------+---------+--------+
    Done!
    ```

    b. **Test Against Invalid Terraform Config File:**
    ```
    nctl scan terraform --resources test/bad-01.tf --policies check-public-endpoint.yaml --details
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

    +-----------------------+-----------------------+----------------+--------------------------------+--------+
    |        POLICY         |         RULE          |    RESOURCE    |            MESSAGE             | RESULT |
    +-----------------------+-----------------------+----------------+--------------------------------+--------+
    | check-public-endpoint | check-public-endpoint | test/bad-01.tf |  Public access to EKS cluster  |  fail  |
    |                       |                       |                |  endpoint must be explicitly   |        |
    |                       |                       |                |          set to false          |        |
    +-----------------------+-----------------------+----------------+--------------------------------+--------+
    Done! 1 policy violation(s) detected.
    ```

---