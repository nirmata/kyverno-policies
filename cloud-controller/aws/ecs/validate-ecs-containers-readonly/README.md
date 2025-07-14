# Validate ECS Containers Readonly Policy

When managing containers within AWS ECS, it's crucial to enforce security measures to prevent unauthorized modifications. One significant aspect is restricting write access to the containers' root filesystems. To achieve this, AWS ECS provides a parameter called `readonlyRootFilesystem` in the container definition. This parameter, when set to `false`, allows write access, and when set to `true`, ensures read-only access. 

## Policy Details:

- **Policy Name:** validate-ecs-containers-readonly
- **Check Description:** Ensure ECS containers are limited to read-only access to root filesystems.
- **Policy Category:** AWS ECS Best Practices


## Testing Instructions

### Testing with Nirmata Cloud Admission Controller

#### Prerequisites
- AWS CLI properly configured with authentication
- Nirmata Cloud Controller installed and configured

#### Steps to Test

1. **Create Policy in the Cluster**
   ```bash
   kubectl apply -f validate-ecs-containers-readonly.yaml
   ```

2. **Test Invalid Configuration**
   ```bash
   aws ecs register-task-definition \
    --family test-task-readonly-disabled \
    --container-definitions '[{
        "name": "nginx",
        "image": "nginx:latest",
        "memory": 128,
        "cpu": 128,
        "essential": true,
        "readonlyRootFilesystem": false
    }]' \
    --region us-west-2
   ```
   This will be rejected as logging is not configured.
   ```bash
    An error occurred (406) when calling the RegisterTaskDefinition operation: validate-ecs-containers-readonly.validate-ecs-containers-readonly TEST: -> ECS Containers should have read-only access to its root filesystem
        -> all[0].check.data.~.(containerDefinitions)[1].readonlyRootFilesystem: Invalid value: false: Expected value: true
   ```
3. **Test Valid Configuration**
   ```bash
   aws ecs register-task-definition \
    --family test-task-readonly-enabled \
    --container-definitions '[{
        "name": "nginx",
        "image": "nginx:latest",
        "memory": 128,
        "cpu": 128,
        "essential": true,
        "readonlyRootFilesystem": true
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
   2630aa82b951ed511af0f4d015b852b2c7029ea91dc24c708c98560f32d54b1   ECSTaskDefinition   test-task-readonly-enabled__1    1      0      0      0       0      2s
   48457c5ba8463a23bf7f2c8d806ca07eb2058e460eb2a8d814ced53f9af45d9   ECSTaskDefinition   test-task-readonly-null__1       0      1      0      0       0      1s
   99d8733f30df7af3349772fc1b7e76ee4b32c253dfd1321fb65aee66a7a9193   ECSTaskDefinition   test-task-readonly-disabled__2   0      1      0      0       0      2s
   ```