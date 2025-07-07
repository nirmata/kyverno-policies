# Check Public Endpoint Access to AWS EKS

Ensuring that the Amazon EKS public endpoint is not accessible to 0.0.0.0/0 is a fundamental security measure that helps protect your EKS clusters from unauthorized access, security threats, and compliance violations.

## Policy Details

- **Policy Name:** check-public-access-cidr
- **Check Description:** Ensuring that the Amazon EKS public endpoint is not accessible to 0.0.0.0/0
- **Policy Category:** EKS Best Practices 

## Testing Instructions

### Testing with Nirmata Cloud Admission Controller

#### Prerequisites
- AWS CLI properly configured with authentication
- Nirmata Cloud Controller installed and configured

#### Steps to Test

1. **Create Policy in the Cluster**
   ```bash
   kubectl apply -f check-public-access-cidr.yaml
   ```

2. **Test Invalid Configuration**
   ```bash
   aws eks create-cluster \
       --name bad-cluster-1 \
       --role-arn <eks-cluster-role> \
       --resources-vpc-config subnetIds=subnet-id-1,subnet-id-2,endpointPublicAccess=true,endpointPrivateAccess=true \
       --region us-west-2
   ```
   This will be rejected as public endpoint access is not properly restricted.
   ```bash
      An error occurred (406) when calling the CreateCluster operation: check-public-access-cidr.check-public-access-cidr TEST: -> Ensuring that the Amazon EKS public endpoint is not accessible to 0.0.0.0/0
   -> all[0].check.payload.resourcesVpcConfig.((endpointPublicAccess == `false`) || (endpointPublicAccess == `true` && publicAccessCidrs[?@ == '0.0.0.0/0'] | length(@) == `0`)): Invalid value: false: Expected value: true

   ```
3. **Test Valid Configuration**
   ```bash
   aws eks create-cluster \
       --name good-cluster-1 \
       --role-arn <eks-cluster-role> \
       --resources-vpc-config subnetIds=subnet-id-1,subnet-id-2,endpointPublicAccess=true,publicAccessCidrs="192.168.0.0/16",endpointPrivateAccess=true \
       --region us-west-2
   ```
   This will successfully create a cluster as it meets the security requirements.

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
   2b579dca4f31ec8444gde9529cf7d821e578ec6e6fd2c47bde646df43dfb5d6   EkSCluster   good-cluster     1      0      0      0       0      4s
   3a6b9ebd7g42fd9555hef0630dg8e932f689fd7f7ge3d584eef757eg4egc6e7   EKSCluster   bad-cluster      0      1      0      0       0      4s
   ```