# Check Supported AWS EKS K8s Version

Kubernetes rapidly evolves with new features, design updates, and bug fixes. The community releases new Kubernetes minor versions (such as 1.30) on average once every four months. Amazon EKS follows the upstream release and deprecation cycle for minor versions. As new Kubernetes versions become available in Amazon EKS, it is recommended to proactively update your clusters to use the latest available version.

You can read more about it [here](https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html)

## Policy Details:

- **Policy Name:** check-supported-k8s-version
- **Check Description:** Check Supported K8s Version in AWS EKS
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
    kyverno-json scan --payload test/good-test/good-payload-01.json --policy check-supported-k8s-version.yaml --bindings test/binding.yaml
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading bindings ...
    - analyzer -> map[resource:map[type:terraform-plan]]
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - check-supported-k8s-version / check-supported-k8s-version /  PASSED
    Done
    ```

    b. **Test Against Invalid Payload:**
    ```
    kyverno-json scan --payload test/bad-test/bad-payload-01.json --policy check-supported-k8s-version.yaml --bindings test/binding.yaml
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading bindings ...
    - analyzer -> map[resource:map[type:terraform-plan]]
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - check-supported-k8s-version / check-supported-k8s-version /  FAILED
    -> Version specified must be one of these suppported versions ['1.23', '1.24', '1.25', '1.26', '1.27', '1.28', '1.29', '1.30']
    -> all[0].check.~.(planned_values.root_module.resources[?type=='aws_eks_cluster'])[0].values.(!version == `true` || contains($supported_k8s_versions, version)): Invalid value: false: Expected value: true
    Done
    ```

---