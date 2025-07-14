# Validate ECS Task Definition Log Configuration

The LogConfiguration property specifies log configuration options to send to a custom log driver for the container. Having all logs at a central place simplifies troubleshooting and debugging since you don't have to log into individual instances to access container logs. It also allows integration with monitoring tools to set up metrics and alerts based on log data. This policy checks if ECS TaskDefinitions and Services have logConfiguration defined. 

## Policy Details:

- **Policy Name:** validate-ecs-task-definition-log-configuration
- **Check Description:** This policy ensures that logConfiguration is set for ECS Task Definitions
- **Policy Category:** AWS ECS Best Practices


## Testing Instructions

### Testing with Nirmata Cloud Admission Controller

#### Prerequisites
- AWS CLI properly configured with authentication
- Nirmata Cloud Controller installed and configured

#### Steps to Test

1. **Create Policy in the Cluster**
   ```bash
   kubectl apply -f validate-ecs-task-definition-log-configuration.yaml
   ```

2. **Test Invalid Configuration**
   ```bash
   aws ecs register-task-definition \
    --family test-task-log-missing \
    --container-definitions '[{
        "name": "nginx",
        "image": "nginx:latest",
        "cpu": 128,
        "memory": 512,
        "essential": true
    }]' \
    --region us-west-2
   ```
   This will be rejected as logging is not configured.
   ```bash
    An error occurred (406) when calling the RegisterTaskDefinition operation: validate-ecs-task-definition-log-configuration.validate-ecs-task-definition-log-configuration TEST: -> logConfiguration must be set for ECS Task Definition
     -> all[0].check.data.~.(containerDefinitions)[0].(!logConfiguration): Invalid value: true: Expected value: false
   ```
3. **Test Valid Configuration**
   ```bash
   aws ecs register-task-definition \
    --family test-task-log-configured \
    --container-definitions '[{
        "name": "nginx",
        "image": "nginx:latest",
        "cpu": 128,
        "memory": 512,
        "essential": true,
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "/ecs/test-task",
                "awslogs-region": "us-west-2",
                "awslogs-stream-prefix": "nginx"
            }
        }
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
   0faad6bde645789db0b36f5a0d445dc4b91a1e5c49aa4590ed21f6b44fc9d74   ECSTaskDefinition   fargate-task-definition__7    1      0      0      0       0      25s
   19e9f7d4a9f64d2c176c6acecb44ea26673cb795c85890d303298b078c54226   ECSTaskDefinition   test-task-log-missing__1      0      1      0      0       0      24s
   84a7d22b26aa00c219ab4b8252a1593efc0028454537d710d1c7ce32879376b   ECSTaskDefinition   test-task-log-configured__2   1      0      0      0       0      24s

   ```