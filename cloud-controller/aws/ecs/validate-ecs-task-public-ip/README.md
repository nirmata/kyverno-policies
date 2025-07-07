# Validate ECS Task Public IP

A public IP address is an IP address that is reachable from the internet. If you launch your Amazon ECS instances with a public IP address, then your Amazon ECS instances are reachable from the internet. Amazon ECS services should not be publicly accessible, as this may allow unintended access to your container application servers.

## Policy Details:

- **Policy Name:** validate-ecs-task-public-ip
- **Check Description:** ECS tasks with public IP address enabled, are easily reachable from the internet. This policy validates whether public IP address is enabled on the ECS task.
- **Policy Category:** AWS ECS Best Practices

## Testing Instructions

### Testing with Nirmata Cloud Admission Controller

#### Prerequisites
- AWS CLI properly configured with authentication
- Nirmata Cloud Controller installed and configured

#### Steps to Test

1. **Create Policy in the Cluster**
   ```bash
   kubectl apply -f validate-ecs-task-public-ip.yaml
   ```

2. **Test Invalid Configuration**
   ```bash
   aws ecs create-service \
    --cluster my-cluster \
    --service-name test-service-public-ip-enabled \
    --task-definition my-task-definition \
    --desired-count 1 \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=[subnet-abc123],assignPublicIp=ENABLED}" \
    --region us-west-2
   ```
   This will be rejected as pidmode is host.
   ```bash
    An error occurred (406) when calling the RunTask operation: validate-ecs-task-public-ip.validate-ecs-task-public-ip TEST: -> Public IP address should not be enabled 
     -> all[0].check.data.networkConfiguration.awsvpcConfiguration.assignPublicIp: Invalid value: "ENABLED": Expected value: "DISABLED"
   ```
3. **Test Valid Configuration**
   ```bash
   aws ecs create-service \
    --cluster my-cluster \
    --service-name test-service-public-ip-disabled \
    --task-definition my-task-definition \
    --desired-count 1 \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=[subnet-abc123],assignPublicIp=DISABLED}" \
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
   NAME                                                              KIND         NAME                                       PASS   FAIL   WARN   ERROR   SKIP   AGE
   716079123b201b0669992507a712d81998515eb2ccde3bb533f388a38585844   ECSService   good-cluster__bad-service__good-cluster    0      1      0      0       0      1s
   c55bb786fb2a3a92f89c08ca3d80d9d4d8f36e00a098c053d1d22a98203d0f2   ECSService   good-cluster__good-service__good-cluster   1      0      0      0       0      1s

   ```