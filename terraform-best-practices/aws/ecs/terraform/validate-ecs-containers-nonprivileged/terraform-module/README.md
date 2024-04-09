# ECS containers should run as non-privileged

It is important to ensure that ECS containers run without elevated privileges to enhance security. The policy checks the privileged parameter in the container definition and raises a concern if it is set to `true`. When a container is granted elevated permissions (similar to the root user) by having privileged set to true, it poses potential security risks on the host container instance.

It is advised against running containers with elevated privileges, as this may compromise the overall security of your ECS task definitions. It is recommended to avoid using privileged and, instead, specify precise privileges using specific parameters. This approach allows for a more controlled and secure execution environment, minimizing the risks associated with running containers with unnecessary elevated privileges.

### Policy Validation Testing Instructions

To evaluate and test the policy ensuring if the privileged parameter in the container definition is set to `false` (is default) in the Terraform plan payload, follow the steps outlined below:

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
    kyverno-json scan --policy validate-ecs-containers-nonprivileged.yaml --payload policy-test/good-payload.json
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - validate-ecs-containers-nonprivileged / validate-ecs-containers-nonprivileged /  PASSED
    Done
    ```

    b. **Test Against Invalid Payload:**
    ```
    kyverno-json scan --policy validate-ecs-containers-nonprivileged.yaml --payload policy-test/bad-payload.json
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - validate-ecs-containers-nonprivileged / validate-ecs-containers-nonprivileged /  FAILED: Containers must be set to non privileged.: any[0].check.(configuration.root_module.module_calls.ecs_container_definition.expressions.privileged || `{}` | length(keys(@)) > `0`): Invalid value: true: Expected value: false; any[1].check.configuration.root_module.module_calls.ecs_container_definition.expressions.privileged.constant_value: Invalid value: true: Expected value: false
    Done
    ```

---
