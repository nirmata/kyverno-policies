# Check Standard Supported K8s Version on AWS EKS

Using a standard Kubernetes version ensures access to the latest features, security updates, and community support. It’s more cost-effective than extended support versions, as AWS charges extra for extended support while standard versions offer faster updates and new capabilities at no additional cost.

## Policy Details:

- **Policy Name:** check-supported-k8s-version
- **Check Description:** Ensure AWS EKS Cluster is created using Standard Supported K8s Version
- **Policy Category:** EKS Best Practices 
## Testing Instructions

### Testing with Nirmata Cloud Admission Controller

#### Prerequisites
- AWS CLI properly configured with authentication
- Nirmata Cloud Controller installed and configured

#### Steps to Test

1. **Create Policy in the Cluster**
   ```bash
   kubectl apply -f check-supported-k8s-version.yaml
   ```

2. **Test Invalid Configuration**
   ```bash
   aws eks create-cluster \
    --name bad-eks-cluster \
    --role-arn <eks-cluster-role> \
    --version 1.27 \
    --resources-vpc-config subnetIds=subnet-id-1,subnet-id-2 \
    --region us-west-2
   ```
   This will be rejected as k8s version is not configured correctly.
   ```bash
   An error occurred (406) when calling the CreateCluster operation: check-supported-k8s-version.check-supported-k8s-version TEST: -> Version specified must be one of these suppported versions ['1.29', '1.30', '1.31']
   -> all[0].check.payload.version.(contains($supported_k8s_versions, @)): Invalid value: false: Expected value: true
   ```

3. **Test Valid Configuration**
   ```bash
   aws eks create-cluster \
    --name good-eks-cluster \
    --role-arn <eks-cluster-role> \
    --version 1.31 \
    --resources-vpc-config subnetIds=subnet-id-1,subnet-id-2 \
    --region us-west-2
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
   1a468eba2818db9333ede8428bf6c910d467db5d5fc1b36adc535ce32cea2c5   EkSCluster   good-cluster     1      0      0      0       0      5s
   1c4a23fad560fe66ee7d139b456451d8aaf7c75a9aaa12007a37f1d6f3056b9   EKSCluster   bad-cluster      0      1      0      0       0      5s
   ```