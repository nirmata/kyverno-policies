# Check Public Endpoint access to AWS EKS

Disabling the public endpoint minimizes the risk of unauthorized access and potential security breaches by reducing the attack surface of the EKS control plane. 
It protects against external threats and enforces network segmentation, restricting access to only trusted entities within the network environment. 
This measure helps organizations meet compliance requirements, maintains operational security, and safeguards the reliability and performance of Kubernetes clusters.

To disable public access to the control plane, ensure that **endpointPublicAccess** is set to *false* explicitly. You can read more about endpoint access control [here](https://docs.aws.amazon.com/eks/latest/userguide/cluster-endpoint.html)


## Policy Details

- **Policy Name:** check-public-endpoint
- **Check Description:** Ensure public endpoint access to AWS EKS is disabled
- **Policy Category:** EKS Best Practices 

## Testing Instructions

### Testing with Nirmata Cloud Admission Controller

#### Prerequisites
- AWS CLI properly configured with authentication
- Nirmata Cloud Controller installed and configured

#### Steps to Test

1. **Create Policy in the Cluster**
   ```bash
   kubectl apply -f check-public-endpoint.yaml
   ```

2. **Test Invalid Configuration**
   ```bash
   aws eks create-cluster \
    --name bad-eks-cluster \
    --role-arn <eks-cluster-role> \
    --resources-vpc-config subnetIds=subnet-id-1,subnet-id-2 \
    --region us-west-2
   ```
   This will be rejected as public endpoint access is not properly restricted.
   ```bash
   An error occurred (406) when calling the CreateCluster operation: check-public-endpoint.check-public-endpoint TEST: -> Public access to EKS cluster endpoint must be explicitly set to false
   -> all[0].check.payload.resourcesVpcConfig.endpointPublicAccess: Invalid value: true: Expected value: false
   ```
3. **Test Valid Configuration**
   ```bash
   aws eks create-cluster \
    --name good-eks-cluster \
    --role-arn <eks-cluster-role> \
    --resources-vpc-config subnetIds=subnet-id-1,subnet-id-2, endpointPublicAccess=false,endpointPrivateAccess=true \
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
   jfdseundsdfie832449852fhdgfsbesoesdjx43j3fd2c47bde646df43dfb5d6   EkSCluster   good-cluster     1      0      0      0       0      11s
   eow3nvdl423bb6knkbsackoina8345m2f689fd7f7ge3d584eef757eg4egc6e7   EKSCluster   bad-cluster      0      1      0      0       0      11s
   ```