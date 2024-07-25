# Check Nodegroup Remote Access

As a general security measure, it's crucial to ensure that your AWS EKS node group does not have implicit SSH access from 0.0.0.0/0, thus not being accessible over the internet. This protects your EKS node group from unauthorized access by external entities.

## Policy Details:

- **Policy Name:** check-nodegroup-remote-access
- **Check Description:** Ensure AWS EKS node group does not have implicit SSH access from 0.0.0.0/0
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
    kyverno-json scan --policy check-nodegroup-remote-access.yaml --payload test/good-payload-01.json --bindings test/binding.yaml
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading bindings ...
    - analyzer -> map[resource:map[type:terraform-plan]]
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - check-nodegroup-remote-access / check-nodegroup-remote-access /  PASSED
    Done
    ```

    b. **Test Against Invalid Payload:**
    ```
    kyverno-json scan --policy check-nodegroup-remote-access.yaml --payload test/bad-payload-01.json --bindings test/binding.yaml
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading bindings ...
    - analyzer -> map[resource:map[type:terraform-plan]]
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - check-nodegroup-remote-access / check-nodegroup-remote-access /  FAILED
    -> AWS EKS node group should not have implicit SSH access from 0.0.0.0/0 If `ec2_ssh_key` is specified and `source_security_group_ids` is not specified for the EKS Node Group,  either port 3389 for Windows or port 22 for other operating systems will be opened on the worker nodes to the Internet which can lead to unauthorized access
    -> all[0].check.~.(planned_values.root_module.resources[?type=='aws_eks_node_group'])[0].~.(values.remote_access || `[]`)[0].((!ec2_ssh_key == `false`) && (!source_security_group_ids == `true`)): Invalid value: true: Expected value: false
    Done
    ```

---