# Validate ECS Container Insights Policy

Container Insights plays a crucial role in AWS ECS by providing diagnostic information, including details about container restart failures, aiding in the quick identification and resolution of issues. This policy ensures that ECS clusters have Container Insights enabled for effective monitoring and issue isolation.

## Policy Details:

- **Policy Name:** validate-ecs-container-insights-enabled
- **Check Description:** Verify if ECS clusters have Container Insights enabled.
- **Policy Category:** AWS ECS Best Practices

## Testing Instructions

### Testing with Nirmata Cloud Admission Controller

#### Prerequisites
- AWS CLI properly configured with authentication
- Nirmata Cloud Controller installed and configured

#### Steps to Test

1. **Create Policy in the Cluster**
   ```bash
   kubectl apply -f validate-ecs-container-insights-enabled.yaml
   ```

2. **Test Invalid Configuration**
   ```bash
   aws ecs create-cluster \
    --cluster-name test-cluster-no-insights \
    --settings name=containerInsights,value=disabled \
    --region us-west-2
   ```
   This will be rejected as logging is not configured.
   ```bash
    An error occurred (406) when calling the CreateCluster operation: validate-ecs-container-insights-enabled.validate-ecs-container-insights-enabled TEST: -> ECS container insights must be enabled
     -> all[0].check.data.~.(clusterSettings[?name == 'containerInsights'] || settings[?name == 'containerInsights'])[0].value: Invalid value: "disabled": Expected value: "enabled"
   ```
3. **Test Valid Configuration**
   ```bash
   aws ecs create-cluster \
    --cluster-name test-cluster-with-insights \
    --settings name=containerInsights,value=enabled \
    --region us-west-2
   ```
   This will successfully create a cluster as it meets the requirements.

### Testing with Nirmata Cloud Scanner

1. Ensure the Cloud Scanner Pod is running with required credentials.

2. Create test clusters using the commands above.

3. Check cluster policy reports:
   ```bash
   kubectl get clusterpolicyreports
   ```

   Example output:
   ```
   NAME                                                              KIND         NAME                         PASS   FAIL   WARN   ERROR   SKIP   AGE
   a7d62beddb093c48cb22499d762dbd0a27c10fbd5b36a3d7a7f9b265c1a4eb6   ECSCluster   test-cluster-with-insights   1      0      0      0       0      0s
   e2c7f9c41bfbb9ed7b22a181fb82a5ec81dcbc2b02b8d3429642d1d7b7ff870   ECSCluster   ResourceExample              0      1      0      0       0      0s
   ff68c3b72921d75d146a0c977101d009aea00aad0f5654d79e7d51ac4a480d6   ECSCluster   test-cluster-no-insights     0      1      0      0       0      0s

   ```