# Check Control Plane Logging

Amazon EKS control plane logging is a best practice for enhancing security, monitoring, troubleshooting, performance optimization, and operational management of your Kubernetes clusters. By capturing comprehensive logs of control plane activities, you can effectively manage and secure your EKS infrastructure while ensuring compliance with regulatory requirements.

You should enable control plane logging for all these types:
- `api`
- `audit`
- `authenticator`
- `controllerManager`
- `scheduler`

For detailed information about the log types, refer to the [EKS Control Plane Logging Documentation](https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html).

## Policy Details

- **Policy Name:** check-control-plane-logging
- **Check Description:** Ensure Amazon EKS control plane logging is enabled for all log types
- **Policy Category:** EKS Best Practices 

## Testing Instructions

### Testing with Nirmata Cloud Admission Controller

#### Prerequisites
- AWS CLI properly configured with authentication
- Nirmata Cloud Controller installed and configured

#### Steps to Test

1. **Create Policy in the Cluster**
   ```bash
   kubectl apply -f check-control-plane-logging.yaml
   ```

2. **Test Invalid Configuration**
   ```bash
   aws eks create-cluster \
       --name bad-eks-cluster-01 \
       --role-arn <eks-cluster-role> \
       --resources-vpc-config subnetIds=subnet-id-1,subnet-id-2
   ```
   This will be rejected as logging is not configured.
   ```bash
      An error occurred (406) when calling the CreateCluster operation: check-control-plane-logging.check-control-plane-logging TEST: -> EKS control plane logging must be enabled for all log types
   -> any[0].check.payload.logging.clusterLogging.enabledTypes[*].type == ['api', 'audit', 'authenticator', 'controllerManager', 'scheduler']): Invalid value: "null": Expected value: true
   -> EKS control plane logging must be enabled for all log types
   -> any[1].check.payload.logging.~.(clusterLogging[?enabled == `true`])[0].(types).(contains(@, 'api') && contains(@, 'audit') && contains(@, 'authenticator') && contains(@, 'controllerManager') && contains(@, 'scheduler')): Invalid value: false: Expected value: true
   ```
3. **Test Valid Configuration**
   ```bash
   aws eks create-cluster \
       --name good-eks-cluster-01 \
       --role-arn <eks-cluster-role> \
       --resources-vpc-config subnetIds=subnet-id-1,subnet-id-2 \
       --logging '{"clusterLogging":[{"types":["api","audit","authenticator","controllerManager","scheduler"],"enabled":true}]}'
   ```
   This will successfully create a cluster as it meets the logging requirements.

### Testing with Nirmata Cloud Scanner

1. Ensure the Cloud Scanner Pod is running with required credentials.

2. Create test clusters using the commands above.

3. Check cluster policy reports:
   ```bash
   kubectl get clusterpolicyreports
   ```

   Example output:
   ```
   NAME                                                              KIND         NAME             PASS   FAIL   WARN   ERROR   SKIP   AGE
   1a468eba2818db9333ede8428bf6c910d467db5d5fc1b36adc535ce32cea2c5   EkSCluster   good-cluster     1      0      0      0       0      4s
   1c4a23fad560fe66ee7d139b456451d8aaf7c75a9aaa12007a37f1d6f3056b9   EKSCluster   bad-cluster      0      1      0      0       0      4s
   ```