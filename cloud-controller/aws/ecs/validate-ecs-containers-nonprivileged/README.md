# ECS Containers Should Run as Non-Privileged

It is important to ensure that ECS containers run without elevated privileges to enhance security. The policy checks the privileged parameter in the container definition and raises a concern if it is set to `true`. When a container is granted elevated permissions (similar to the root user) by having privileged set to true, it poses potential security risks on the host container instance.

It is advised against running containers with elevated privileges, as this may compromise the overall security of your ECS task definitions. It is recommended to avoid using privileged and, instead, specify precise privileges using specific parameters. This approach allows for a more controlled and secure execution environment, minimizing the risks associated with running containers with unnecessary elevated privileges.

## Policy Details:

- **Policy Name:** validate-ecs-containers-nonprivileged
- **Check Description:** The policy checks the privileged parameter in the container definition and raises a concern if it is set to `true`.
- **Policy Category:** AWS ECS Best Practices


## Testing Instructions

### Testing with Nirmata Cloud Admission Controller

#### Prerequisites
- AWS CLI properly configured with authentication
- Nirmata Cloud Controller installed and configured

#### Steps to Test

1. **Create Policy in the Cluster**
   ```bash
   kubectl apply -f validate-ecs-containers-nonprivileged.yaml
   ```

2. **Test Invalid Configuration**
   ```bash
   aws ecs register-task-definition \
    --family test-task-privileged-enabled \
    --container-definitions '[{
        "name": "nginx",
        "image": "nginx:latest",
        "memory": 128,
        "cpu": 128,
        "essential": true,
        "privileged": true
    }]' \
    --region us-west-2

   ```
   This will be rejected as privileged is not configured.
   ```bash
    An error occurred (406) when calling the RegisterTaskDefinition operation: validate-ecs-containers-nonprivileged.validate-ecs-containers-nonprivileged bad-task-definition-01: -> The `privileged` field, if present, should be set to `false`
     -> all[0].check.data.~.(containerDefinitions)[1].(!!privileged): Invalid value: true: Expected value: false
   ```
3. **Test Valid Configuration**
   ```bash
   aws ecs register-task-definition \
    --family test-task-privileged-disabled \
    --container-definitions '[{
        "name": "nginx",
        "image": "nginx:latest",
        "memory": 128,
        "cpu": 128,
        "essential": true,
        "privileged": false
    }]' \
    --region us-west-2

   ```
   This will successfully create a taskdefinition as it meets the requirements.

### Testing with Nirmata Cloud Scanner

1. Ensure the Cloud Scanner Pod is running with required credentials.

2. Create test clusters using the commands above.

3. Check cluster policy reports:
   ```bash
   kubectl get clusterpolicyreports
   ```

   Example output:
   ```
   NAME                                                              KIND                NAME                               PASS   FAIL   WARN   ERROR   SKIP   AGE
   0faad6bde645789db0b36f5a0d445dc4b91a1e5c49aa4590ed21f6b44fc9d74   ECSTaskDefinition   fargate-task-definition__7         1      0      0      0       0      6s
   2bdf2a111787fbd894bfd8a662758b3a0593fa6d0e3e7ae60259876f83a83ac   ECSTaskDefinition   test-task-privileged-disabled__2   1      0      0      0       0      6s
   48482c99d0414b0f13a98aa91131ac7b2042a12a7ec26a70e9ab14c71030a78   ECSTaskDefinition   test-task-privileged-enabled__1    0      1      0      0       0      6s

   ```