# Validate ECS Task Definition Non Root User

This policy checks if ECSTaskDefinitions specify a user for Amazon Elastic Container Service (Amazon ECS) EC2 launch type containers to run on. The rule fails if the `user` parameter is not present or is `root`. Running containers as non-root users can help prevent running commands with root privileges which adds an extra layer of security by limiting the potential damage a compromised container can do. It also follows the security principle of least privilege, which dictates that applications and processes should operate with minimum privileges necessary to perform their functions.

## Policy Details:

- **Policy Name:** validate-ecs-task-definition-nonroot-user
- **Check Description:**  For ECS EC2 containers, `user` parameter should not be set to `root`
- **Policy Category:** AWS ECS Best Practices

## Testing Instructions

### Testing with Nirmata Cloud Admission Controller

#### Prerequisites
- AWS CLI properly configured with authentication
- Nirmata Cloud Controller installed and configured

#### Steps to Test

1. **Create Policy in the Cluster**
   ```bash
   kubectl apply -f validate-ecs-task-definition-nonroot-user.yaml
   ```

2. **Test Invalid Configuration**
   ```bash
   aws ecs register-task-definition \
    --family test-task-user-missing \
    --container-definitions '[{
        "name": "nginx",
        "image": "nginx:latest",
        "cpu": 128,
        "memory": 512,
        "essential": true,
        "user": "root"
    }]' \
    --region us-west-2
   ```
   This will be rejected as user is not configured.
   ```bash
    An error occurred (406) when calling the RegisterTaskDefinition operation: validate-ecs-task-definition-nonroot-user.validate-ecs-task-definition-nonroot-user TEST: -> For ECS EC2 containers, `user` parameter should not be unset or be root
     -> all[0].check.data.~.(containerDefinitions)[0].(user == null || user == 'root' || user == '0' || starts_with(user, '0:') || ends_with(user, ':0')): Invalid value: true: Expected value: false
   ```
3. **Test Valid Configuration**
   ```bash
   aws ecs register-task-definition \
    --family test-task-user-nonroot \
    --container-definitions '[{
        "name": "nginx",
        "image": "nginx:latest",
        "cpu": 128,
        "memory": 512,
        "essential": true,
        "user": "1000:1000"
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
   NAME                                                              KIND                NAME                         PASS   FAIL   WARN   ERROR   SKIP   AGE
   0faad6bde645789db0b36f5a0d445dc4b91a1e5c49aa4590ed21f6b44fc9d74   ECSTaskDefinition   fargate-task-definition__7   0      1      0      0       0      77s
   200a87a65d36aa4ade8f3c8fc849ef766b4eb0dcccc106575f55c6d3e801e33   ECSTaskDefinition   test-task-user-nonroot__3    1      0      0      0       0      77s
   652c9c124ac391d329e8ec51b7043cff3d4620baaa0d11c7f3e8ad50646e52d   ECSTaskDefinition   test-task-user-root__2       0      1      0      0       0      77s
   ```