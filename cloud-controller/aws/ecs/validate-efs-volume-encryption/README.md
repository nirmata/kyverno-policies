# Validate EFS Volume Encryption 

Amazon EFS file systems can be used with Amazon ECS to export file system data across your fleet of container instances. To ensure encryption is enabled in transit, this policy validates whether `transitEncryption` is set to ENABLED in the task definition.

## Policy Details:

- **Policy Name:** validate-efs-volume-encryption
- **Check Description:** Ensure Transit Encryption is enabled for EFS volumes in ECS Task definitions
- **Policy Category:** AWS ECS Best Practices


## Testing Instructions

### Testing with Nirmata Cloud Admission Controller

#### Prerequisites
- AWS CLI properly configured with authentication
- Nirmata Cloud Controller installed and configured

#### Steps to Test

1. **Create Policy in the Cluster**
   ```bash
   kubectl apply -f validate-efs-volume-encryption.yaml
   ```

2. **Test Invalid Configuration**
   ```bash
   aws efs create-file-system --creation-token "my-efs-test" 
   ```
   Note down the FileSystemId (e.g., fs-xxxxxxxx).
   ```bash
   {
      "family": "bad-efs-volume-test",
      "executionRoleArn": "arn:aws:iam::844333597536:role/ecsTaskExecutionRole",
      "networkMode": "awsvpc",
      "containerDefinitions": [
         {
            "name": "nginx-container",
            "image": "nginx",
            "memory": 512,
            "cpu": 256,
            "essential": true,
            "mountPoints": [
            {
               "sourceVolume": "efs-volume",
               "containerPath": "/mnt"
            }
            ]
         }
      ],
      "volumes": [
         {
            "name": "efs-volume",
            "efsVolumeConfiguration": {
            "fileSystemId": "fs-0ae804f20d83d181c",
            "transitEncryption": "DISABLED"
            }
         }
      ]
   }
   ```
   Above given is a task-definition.json file can be used to create TaskDefinition.
   ```bash
   aws ecs register-task-definition --cli-input-json file://task-definition.json
   ```
   Since `transitEncryption` is set to DISABLED the TaskDefination create will fail.
   ```bash   
   An error occurred (406) when calling the Register TaskDefinition operation: validate-efs-volume-encryption.validate-efs-volume-encryption TEST: -> Transit Encryption should be set to ENABLED for EFS volumes in ECS Task Definitions

   -> all[0].check.payload.-.(volumes [?eFSVolumeConfiguration || efsVolume Configuration])[0]. (eFSVolume Configuration || efsVolumeConfiguration).transitEncryption: Invalid value: "DISABLED": Expected value: "ENABLED
   ```
3. **Test Valid Configuration**
   For valid configuration change the transitEncryption to ENABLED and re-run the above command.
   ```bash
   aws ecs register-task-definition --cli-input-json file://task-definition.json
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
   0faad6bde645789db0b36f5a0d445dc4b91a1e5c49aa4590ed21f6b44fc9d74   ECSTaskDefinition   fargate-task-definition__7   1      0      0      0       0      1s
   1443496a25779df2e30ffd96b0d5446e3a99a92108ad473929ac0a1efdb7c95   ECSTaskDefinition   bad-efs-volume-test__1       0      1      0      0       0      1s
   61d5d2004a5e1f50480f678ad6838562b578a3ee798c9c081043149767b356b   ECSTaskDefinition   good-efs-volume-test__1      1      0      0      0       0      1s
   ```