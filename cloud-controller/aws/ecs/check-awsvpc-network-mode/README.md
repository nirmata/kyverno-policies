# Check `awsvpc` Network Mode

When you're running containers on AWS, managing the networking becomes crucial, especially when leveraging the benefits of hosting multiple containers on a single host. There are various network modes to choose from:

1. **Host mode:** This is the most basic network mode in Amazon ECS. It essentially shares the host's networking stack with the containers.

2. **Bridge mode:** This mode employs a virtual network bridge to establish a layer between the host and the container's networking.

3. **AWSVPC mode:** Here, Amazon ECS generates and oversees an Elastic Network Interface (ENI) for each task, providing each task with a distinct private IP address within the VPC.

By default, the network mode for ECS tasks is set to `bridge`. However, we will opt for the `awsvpc` network mode here. This choice is strategic, as it facilitates controlled traffic flow between tasks and enhances security. `awsvpc` offers task-level network isolation for tasks running on Amazon EC2. Importantly, it's the exclusive network mode allowing the assignment of security groups to tasks.

To formalize our approach, it's prudent to establish a policy that ensures the usage of 'awsvpc' network mode. This policy aligns with our security strategy by adding an extra layer of protection through task-level isolation and the ability to apply security groups at the task level. Therefore, adopting and enforcing this policy safeguards our containerized infrastructure while optimizing networking capabilities on AWS.

## Policy Details:

- **Policy Name:** check-awsvpc-network-mode
- **Check Description:** This policy ensures that task definitions, tasks and services make use of the awsvpc network mode
- **Policy Category:** AWS ECS Best Practices


## Testing Instructions

### Testing with Nirmata Cloud Admission Controller

#### Prerequisites
- AWS CLI properly configured with authentication
- Nirmata Cloud Controller installed and configured

#### Steps to Test

1. **Create Policy in the Cluster**
   ```bash
   kubectl apply -f check-awsvpc-network-mode.yaml
   ```

2. **Test Invalid Configuration**
   ```bash
   aws ecs register-task-definition \
    --family test-task \
    --network-mode bridge \
    --container-definitions '[{
        "name": "nginx",
        "image": "nginx:latest",
        "memory": 128,
        "cpu": 128,
        "essential": true,
        "portMappings": [{
            "containerPort": 80,
            "hostPort": 80,
            "protocol": "tcp"
        }]
    }]' \
    --region us-west-2
   ```
   This will be rejected as networkMode is not configured properly.
   ```bash
    An error occurred (406) when calling the RegisterTaskDefinition operation: check-awsvpc-network-mode.check-task-definition-awsvpc-network-mode bad-task-definition-01: -> ECS task definitions are required to use awsvpc network mode.
     -> all[0].check.data.networkMode: Invalid value: "bridge": Expected value: "awsvpc"
   ```
3. **Test Valid Configuration**
   ```bash
   aws ecs register-task-definition \
    --family test-task \
    --network-mode awsvpc \
    --container-definitions '[{
        "name": "nginx",
        "image": "nginx:latest",
        "memory": 128,
        "cpu": 128,
        "essential": true,
        "portMappings": [{
            "containerPort": 80,
            "hostPort": 80,
            "protocol": "tcp"
        }]
    }]' \
    --region us-west-2
   ```
   This will successfully create a task-definition.

### Testing with Nirmata Cloud Scanner

1. Ensure the Cloud Scanner Pod is running with required credentials.

2. Create test clusters using the commands above.

3. Check cluster policy reports:
   ```bash
   kubectl get clusterpolicyreports
   ```

   Example output:
   ```
   NAME                                                              KIND                NAME                         PASS   FAIL   WARN   ERROR   SKIP   AGE
   b64eb4c8c28bfe96b775459272e05cbed3ee3da99bad2a512bb9d0461f7c597   ECSTaskDefinition   good-awsvpc-test__1          1      0      0      0       0      1s
   69733e9802640cd4abac28d92c3b3b366ff5d451c97ead8763d640ba76f6aa1   ECSTaskDefinition   bad-awsvpc-test__1           0      1      0      0       0      1s
   ```