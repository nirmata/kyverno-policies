# Validate ECS Task Definition User for Host Mode Policy

This policy aims to identify and address unauthorized permissions in your active Amazon Elastic Container Service (Amazon ECS) task definitions that utilize the `host` network mode. The rule categorizes task definitions with NetworkMode set to `host` as NON_COMPLIANT under the following conditions: container definitions with privileged set to false or empty and user set to root or empty.

In scenarios where tasks employ the `host` network mode, it's crucial to avoid running containers with the root user (UID 0) for enhanced security. As a recommended security practice, it is recommended to opt for a non-root user.

## Policy Details:

- **Policy Name:** validate-ecs-task-definition-user-for-host-mode-check
- **Check Description:** This policy ensures that ECS task definitions avoid using the root user for the host network mode when privileged is set to false or is not specified. 
- **Policy Category:** AWS ECS Best Practices

## Testing Instructions

### Testing with Nirmata Cloud Admission Controller

#### Prerequisites
- AWS CLI properly configured with authentication
- Nirmata Cloud Controller installed and configured

#### Steps to Test

1. **Create Policy in the Cluster**
   ```bash
   kubectl apply -f validate-ecs-task-definition-user-for-host-mode-check.yaml
   ```

2. **Test Invalid Configuration**
   ```bash
   aws ecs register-task-definition \
    --family test-task-user-root-host \
    --network-mode host \
    --container-definitions '[{
        "name": "nginx",
        "image": "nginx:latest",
        "cpu": 128,
        "memory": 512,
        "essential": true,
        "privileged": false,
        "user": "root"
    }]' \
    --region us-west-2 
   ```
   This will be rejected as pidmode is host.
   ```bash
    An error occurred (406) when calling the RegisterTaskDefinition operation: validate-ecs-task-definition-user-for-host-mode-check.validate-ecs-task-definition-user-for-host-mode-check TEST: -> User should be set to a non-root user when NetworkMode is set to host and privileged is set to false or not specified
     -> all[0].check.data.~.(containerDefinitions[?!privileged])[0].(user == null || user == 'root' || user == '0' || starts_with(user, '0:') || ends_with(user, ':0')): Invalid value: true: Expected value: false
   ```
3. **Test Valid Configuration**
   ```bash
   aws ecs register-task-definition \
    --family test-task-user-nonroot-host-privileged-notset \
    --network-mode host \
    --container-definitions '[{
        "name": "nginx",
        "image": "nginx:latest",
        "cpu": 128,
        "memory": 512,
        "essential": true,
        "user": "1001"
    }]' \
    --region us-west-2 \
    --profile devtest-sso
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
   NAME                                                              KIND                NAME                                               PASS   FAIL   WARN   ERROR   SKIP   AGE
   27e9cc574dc650f6749d75356a2ae3ebfef1f1e4b02354feca2f5272640acad   ECSTaskDefinition   test-task-user-nonroot-host-privileged-notset__2   1      0      0      0       0      17s
   a51bea2864a6d3ebf7da086ed71c7fde92cacc7888d84597553553ac6146671   ECSTaskDefinition   test-task-user-root-host__1                        0      1      0      0       0      17s

   ```