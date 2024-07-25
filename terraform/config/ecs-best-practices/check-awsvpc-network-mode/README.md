# Check `awsvpc` network mode

When you're running containers on AWS, managing the networking becomes crucial, especially when leveraging the benefits of hosting multiple containers on a single host. There are various network modes to choose from:

1. **Host mode:** This is the most basic network mode in Amazon ECS. It essentially shares the host's networking stack with the containers.

2. **Bridge mode:** This mode employs a virtual network bridge to establish a layer between the host and the container's networking.

3. **AWSVPC mode:** Here, Amazon ECS generates and oversees an Elastic Network Interface (ENI) for each task, providing each task with a distinct private IP address within the VPC.

By default, the network mode for ECS tasks is set to `bridge`. However, we will opt for the `awsvpc` network mode here. This choice is strategic, as it facilitates controlled traffic flow between tasks and enhances security. `awsvpc` offers task-level network isolation for tasks running on Amazon EC2. Importantly, it's the exclusive network mode allowing the assignment of security groups to tasks.

To formalize our approach, it's prudent to establish a policy that ensures the usage of 'awsvpc' network mode. This policy aligns with our security strategy by adding an extra layer of protection through task-level isolation and the ability to apply security groups at the task level. Therefore, adopting and enforcing this policy safeguards our containerized infrastructure while optimizing networking capabilities on AWS.

### Policy Validation Testing Instructions

To evaluate and test the policy ensuring the presence of the `awsvpc` network mode in the Terraform config file, follow the steps outlined below:

For testing this policy you will need to:
- Make sure you have `nctl` installed on the machine 

1. **Test the Policy with nctl:**
    ```
    nctl scan terraform --resources tf-config.tf --policy policy.yaml
    ```
    
    a. **Test Policy Against Valid Terraform Config File:**
    ```
    nctl scan terraform --resources test/good.tf --policies check-awsvpc-network-mode.yaml 
    ```

    This produces the output:
    ```
    Version: 4.0.1
    Fetching policies...
    Loading policies...
    • found 1 policies
    Running analysis...
    • no errors
    Results...
    +---------------------------+---------------------------+--------------+---------+--------+
    |          POLICY           |           RULE            |   RESOURCE   | MESSAGE | RESULT |
    +---------------------------+---------------------------+--------------+---------+--------+
    | check-awsvpc-network-mode | check-awsvpc-network-mode | test/good.tf |         | pass   |
    +---------------------------+---------------------------+--------------+---------+--------+

    Done
    ```

    b. **Test Against Invalid Terraform Config File:**
    ```
    nctl scan terraform --resources test/bad-01.tf --policies check-awsvpc-network-mode.yaml 
    ```

    This produces the output:
    ```
    Version: 4.0.1
    Fetching policies...
    Loading policies...
    • found 1 policies
    Running analysis...
    • no errors
    Results...
    +---------------------------+---------------------------+----------------+--------------------------------------------------------------------------------+--------+
    |          POLICY           |           RULE            |    RESOURCE    |                                    MESSAGE                                     | RESULT |
    +---------------------------+---------------------------+----------------+--------------------------------------------------------------------------------+--------+
    | check-awsvpc-network-mode | check-awsvpc-network-mode | test/bad-01.tf | ECS services and tasks are required to use awsvpc network mode.:               | fail   |
    |                           |                           |                | all[0].check.~.(resource.aws_ecs_task_definition.values(@)[])[0].network_mode: |        |
    |                           |                           |                | Invalid value: "bridge": Expected value: "awsvpc"                              |        |
    +---------------------------+---------------------------+----------------+--------------------------------------------------------------------------------+--------+

    Done
    ```

---

These instructions are designed to systematically assess the compliance of Terraform config files with the defined policy. Following these steps ensures a thorough examination of the `awsvpc` network mode presence in the terraform config file, allowing for effective validation and adherence to the specified policy.