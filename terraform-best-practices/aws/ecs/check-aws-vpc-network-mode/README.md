# Check `awsvpc` network mode

When you're running containers on AWS, managing the networking becomes crucial, especially when leveraging the benefits of hosting multiple containers on a single host. There are various network modes to choose from:

1. **Host mode:** This is the most basic network mode in Amazon ECS. It essentially shares the host's networking stack with the containers.

2. **Bridge mode:** This mode employs a virtual network bridge to establish a layer between the host and the container's networking.

3. **AWSVPC mode:** Here, Amazon ECS generates and oversees an Elastic Network Interface (ENI) for each task, providing each task with a distinct private IP address within the VPC.

By default, the network mode for ECS tasks is set to `bridge`. However, we will opt for the `awsvpc` network mode here. This choice is strategic, as it facilitates controlled traffic flow between tasks and enhances security. `awsvpc` offers task-level network isolation for tasks running on Amazon EC2. Importantly, it's the exclusive network mode allowing the assignment of security groups to tasks.

To formalize our approach, it's prudent to establish a policy that ensures the usage of 'awsvpc' network mode. This policy aligns with our security strategy by adding an extra layer of protection through task-level isolation and the ability to apply security groups at the task level. Therefore, adopting and enforcing this policy safeguards our containerized infrastructure while optimizing networking capabilities on AWS.

### Policy Validation Testing Instructions

To evaluate and test the policy ensuring the presence of the `awsvpc` network mode in the Terraform plan payload, follow the steps outlined below:

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
    kyverno-json scan --policy check-aws-vpc-network-mode.yaml --payload policy-test/good-payload.json
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - check-awsvpc-network-mode / check-awsvpc-network-mode /  PASSED
    Done
    ```

    b. **Test Against Invalid Payload:**
    ```
    kyverno-json scan --policy check-aws-vpc-network-mode.yaml --payload policy-test/bad-payload.json
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - check-awsvpc-network-mode / check-awsvpc-network-mode /  FAILED: ECS services and tasks are required to use awsvpc network mode.: all[0].check.values.(network_mode=='awsvpc'): Invalid value: false: Expected value: true
    Done
    ```

---

These instructions are designed to systematically assess the compliance of Terraform plans with the defined policy. Following these steps ensures a thorough examination of the `awsvpc` network mode presence in the payload, allowing for effective validation and adherence to the specified policy.