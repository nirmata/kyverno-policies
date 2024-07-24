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
    ```
    kyverno-json scan --payload payload.json --policy policy.yaml
    ```

    a. **Test Policy Against Valid Payload:**
    ```
    kyverno-json scan --payload test/good-test/good-payload-01.json --policy check-public-endpoint.yaml --bindings test/binding.yaml
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading bindings ...
    - analyzer -> map[resource:map[type:terraform-plan]]
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - check-public-endpoint / check-public-endpoint /  PASSED
    Done
    ```

    b. **Test Against Invalid Payload:**
    ```
    kyverno-json scan --payload test/bad-test/bad-payload-01.json --policy check-public-endpoint.yaml --bindings test/binding.yaml
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading bindings ...
    - analyzer -> map[resource:map[type:terraform-plan]]
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - check-public-endpoint / check-public-endpoint /  FAILED
    -> Public access to EKS cluster endpoint must be explicitly set to false
    -> all[0].check.~.(planned_values.root_module.resources[?type=='aws_eks_cluster'])[0].values.~.(vpc_config)[0].(endpoint_public_access): Invalid value: true: Expected value: false
    Done
    ```

---