# Validate ECS Task Definition PID Mode Policy

This policy ensures that Amazon ECS task tefinitions do not share the host's process namespace. If the host's process namespace is shared with containers, it would allow containers to see all of the processes on the host system. This reduces the benefit of process level isolation between the host and the containers. These circumstances could lead to unauthorized access to processes on the host itself, including the ability to manipulate and terminate them. Customers shouldn't share the host's process namespace with containers running on it.

## Policy Details:

- **Policy Name:** validate-ecs-task-definition-pid-mode-check
- **Check Description:** This policy ensures that ECS task definitions do not share the host's process namespace with its containers
- **Policy Category:** AWS ECS Best Practices

## Testing Instructions

### Testing with Nirmata Cloud Admission Controller

#### Prerequisites
- AWS CLI properly configured with authentication
- Nirmata Cloud Controller installed and configured

#### Steps to Test

1. **Create Policy in the Cluster**
   ```bash
   kubectl apply -f validate-ecs-task-definition-pid-mode-check.yaml
   ```

2. **Test Invalid Configuration**
   ```bash
   aws ecs register-task-definition \
    --family test-task-pidmode-host \
    --network-mode bridge \
    --pid-mode host \
    --container-definitions '[{
        "name": "nginx",
        "image": "nginx:latest",
        "cpu": 128,
        "memory": 512,
        "essential": true
    }]' \
    --region us-west-2
   ```
   This will be rejected as pidmode is host.
   ```bash
    An error occurred (406) when calling the RegisterTaskDefinition operation: validate-ecs-task-definition-pid-mode-check.validate-ecs-task-definition-pid-mode-check bad-task-definition-01: -> ECS task definitions containers should not share the host's process namespace
     -> all[0].check.data.(pidMode != 'host'): Invalid value: false: Expected value: true
   ```
3. **Test Valid Configuration**
   ```bash
   aws ecs register-task-definition \
    --family test-task-pidmode-compliant \
    --network-mode bridge \
    --container-definitions '[{
        "name": "nginx",
        "image": "nginx:latest",
        "cpu": 128,
        "memory": 512,
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
   NAME                                                              KIND                NAME                             PASS   FAIL   WARN   ERROR   SKIP   AGE
   1f3afb16351deb7417a844a46502cee16486505c03b241fdc84b02812835c79   ECSTaskDefinition   test-task-pidmode-compliant__1   1      0      0      0       0      21s
   b1ca13769dfac5793680d630599f5b453de20cdb9279db0816a2377eab79098   ECSTaskDefinition   test-task-pidmode-host__1        0      1      0      0       0      21s

   ```