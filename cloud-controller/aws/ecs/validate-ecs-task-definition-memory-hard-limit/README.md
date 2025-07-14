# Validate ECS Task Definition Memory Hard Limit

This policy checks if Amazon Elastic Container Service (ECS) task definitions have a set memory limit for its container definitions. If a memory limit is not set for a container, it can consume excessive memory, potentially starving other containers running on the same host. Therefore, it is crucial to enforce a hard memory limit on each container to prevent resource contention. If a container exceeds its memory limit, it will be terminated by ECS.

## Policy Details:

- **Policy Name:** validate-ecs-task-definition-memory-hard-limit
- **Check Description:** This policy ensures that ECS task definitions and tasks have a memory limit set
- **Policy Category:** AWS ECS Best Practices


## Testing Instructions

### Testing with Nirmata Cloud Admission Controller

#### Prerequisites
- AWS CLI properly configured with authentication
- Nirmata Cloud Controller installed and configured

#### Steps to Test

1. **Create Policy in the Cluster**
   ```bash
   kubectl apply -f validate-ecs-task-definition-memory-hard-limit.yaml
   ```

2. **Test Invalid Configuration**
   ```bash
   aws ecs register-task-definition \
    --family test-task-memory-missing \
    --container-definitions '[{
        "name": "nginx",
        "image": "nginx:latest",
        "cpu": 128,
        "memoryReservation": 1,
        "essential": true
    }]' \
    --region us-west-2
   ```
   This will be rejected as memory is not configured.
   ```bash
    An error occurred (406) when calling the RegisterTaskDefinition operation: validate-ecs-task-definition-memory-hard-limit.validate-ecs-task-definition-memory-hard-limit bad-task-definition-01: -> Memory limit for container definitions should be set in the task definition
     -> all[0].check.data.~.(containerDefinitions)[0].(!memory): Invalid value: true: Expected value: false
   ```
3. **Test Valid Configuration**
   ```bash
   aws ecs register-task-definition \
    --family test-task-memory-set \
    --container-definitions '[{
        "name": "nginx",
        "image": "nginx:latest",
        "memory": 512,
        "cpu": 128,
        "essential": true
    }]' \
    --region us-west-2
   ```
   This will successfully register task-definition as it meets the requirements.

### Testing with Nirmata Cloud Scanner

1. Ensure the Cloud Scanner Pod is running with required credentials.

2. Create test clusters using the commands above.

3. Check cluster policy reports:
   ```bash
   kubectl get clusterpolicyreports
   ```

   Example output:
   ```
   NAME                                                              KIND                NAME                          PASS   FAIL   WARN   ERROR   SKIP   AGE
   010528adb2dbb96869dfdce90cc75e76016f975268af22704451aa3b6c74e6e   ECSTaskDefinition   test-task-memory-minimal__1   0      1      0      0       0      1s
   546fc2e9fba4bc26f6ca353f41d5458eb09bbbfb5bd35278532081dfc843a44   ECSTaskDefinition   test-task-memory-set__2       1      0      0      0       0      1s

   ```