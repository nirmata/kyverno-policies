# Check Control Plane Logging for Amazon EKS

Enabling Amazon EKS control plane logging for all log types is a best practice for enhancing the security, monitoring, troubleshooting, performance optimization, and operational management of your Kubernetes clusters. By capturing comprehensive logs of control plane activities, you can effectively manage and secure your EKS infrastructure while ensuring compliance with regulatory requirements and industry standards.

To enable control plane logging for all types in Amazon EKS, ensure that **enabled_cluster_log_types** includes all these types: "api", "audit", "authenticator", "controllerManager" and "scheduler". You can read more about the log types [here](https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html)

## Policy Details:

- **Policy Name:** check-control-plane-logging
- **Check Description:** Ensure Amazon EKS control plane logging is enabled for all log types
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
    kyverno-json scan --policy check-control-plane-logging.yaml --payload test/good-payload.json --bindings test/binding.yaml
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading bindings ...
    - analyzer -> map[resource:map[type:terraform-plan]]
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - check-control-plane-logging / check-control-plane-logging /  PASSED
    Done
    ```

    b. **Test Against Invalid Payload:**
    ```
    kyverno-json scan --policy check-control-plane-logging.yaml --payload test/bad-payload-01.json --bindings test/binding.yaml
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading bindings ...
    - analyzer -> map[resource:map[type:terraform-plan]]
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - check-control-plane-logging / check-control-plane-logging /  FAILED
    -> EKS control plane logging must be enabled for all log types
    -> all[0].check.~.(planned_values.root_module.resources[?type=='aws_eks_cluster'])[0].(values.enabled_cluster_log_types[] || `[]`).(contains(@, 'api') && contains(@, 'audit') && contains(@, 'authenticator') && contains(@, 'controllerManager') && contains(@, 'scheduler')): Invalid value: false: Expected value: true
    Done
    ```

---