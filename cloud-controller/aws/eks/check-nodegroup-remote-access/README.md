# Check Nodegroup Remote Access

As a general security measure, it's crucial to ensure that your AWS EKS node group does not have implicit SSH access from 0.0.0.0/0, thus not being accessible over the internet. This protects your EKS node group from unauthorized access by external entities.

To avoid unauthorized access of Nodegroup define sourceSecurityGroups. You can read more about Nodegroup Remote Access [here](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-eks-nodegroup-remoteaccess.html)

## Policy Details:

- **Policy Name:** check-nodegroup-remote-access
- **Check Description:** Ensure AWS EKS node group does not have implicit SSH access from 0.0.0.0/0
- **Policy Category:** EKS Best Practices 

## Testing Instructions

### Testing with Nirmata Cloud Admission Controller

#### Prerequisites
- AWS CLI properly configured with authentication
- Nirmata Cloud Controller installed and configured

#### Steps to Test

1. **Create Policy in the Cluster**
   ```bash
   kubectl apply -f check-nodegroup-remote-access.yaml
   ```
2. **Creating a Test Cluster**
    ```bash
    aws eks create-cluster \
    --name example-cluster \
    --role-arn <eks-cluster-role> \
    --resources-vpc-config subnetIds=subnet-id-1,subnet-id-2 \
    --region us-west-2
    ```
3. **Test Invalid Configuration**
   ```bash
   aws eks create-nodegroup \
    --cluster-name example-cluster \
    --nodegroup-name good-example-node-group \
    --node-role arn:aws:iam::<account-id>:role/example-role \
    --subnets subnet-id-1,subnet-id-2 \
    --scaling-config minSize=2,maxSize=4,desiredSize=2 \
    --remote-access ec2SshKey="some-key"
   ```
   This will be rejected as public endpoint access is not properly restricted.

4. **Test Valid Configuration**
   ```bash
   aws eks create-nodegroup \
    --cluster-name example-cluster \
    --nodegroup-name good-example-node-group \
    --node-role arn:aws:iam::<account-id>:role/example-role \
    --subnets subnet-id-1,subnet-id-2 \
    --scaling-config minSize=2,maxSize=4,desiredSize=2 \
    --remote-access ec2SshKey="some-key",sourceSecurityGroups=["sg-12345678"]
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