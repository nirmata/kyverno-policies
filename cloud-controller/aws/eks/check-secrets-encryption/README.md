# Check Secrets Encryption on AWS EKS

Secrets encryption is a crucial security measure that ensures sensitive data, such as secrets, passwords, and credentials, stored within Kubernetes, is encrypted. This adds an essential layer of protection by preventing unauthorized access to confidential information, even in the event of a security breach. By leveraging encryption mechanisms, such as AWS KMS or other providers, Kubernetes ensures that secrets are securely stored and transmitted, reducing the risk of exposure and enhancing the overall security posture of the cluster.

## Policy Details:

- **Policy Name:** check-secrets-encryption
- **Check Description:** Ensure AWS EKS Cluster is created using Secrets Encryption
- **Policy Category:** EKS Best Practices 

## Testing Instructions

### Testing with Nirmata Cloud Admission Controller

#### Prerequisites
- AWS CLI properly configured with authentication
- Nirmata Cloud Controller installed and configured

#### Steps to Test

1. **Create Policy in the Cluster**
   ```bash
   kubectl apply -f check-secrets-encryption.yaml
   ```

2. **Test Invalid Configuration**
The encryptionConfig is not defined with a keyArn
   ```bash
   aws eks create-cluster \
    --name example-cluster \
    --role-arn arn:aws:iam::xxxx:role/example-role \
    --resources-vpc-config subnetIds=subnet-id-1,subnet-id-2 securityGroupIds=sg-xxxx \
    --region us-west-2
   ```
   This will be rejected as secret encryption is not configured.
   ```bash
   An error occurred (406) when calling the CreateCluster operation: check-secrets-encryption.check-secrets-encryption TEST: : all[0].check.payload.(encryptionConfig[].resources[] | contains(@, 'secrets')): Internal error: invalid type for: <nil>, expected: []functions.JpType{"array", "string"}
   ```
3. **Test Valid Configuration**
   ```bash
   aws eks create-cluster \
    --name example-cluster \
    --role-arn arn:aws:iam::ACCOUNT_ID:role/EKSClusterRole \
    --resources-vpc-config subnetIds=subnet-id-1,subnet-id-2 securityGroupIds=sg-xxxx \
    --encryption-config "resources=[secrets],provider={keyArn=arn:aws:kms:us-west-2:xxxx:key/YOUR_KMS_KEY}" \
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
   1a468eba2818db9333ede8428bf6c910d467db5d5fc1b36adc535ce32cea2c5   EkSCluster   good-cluster     1      0      0      0       0      4s
   1c4a23fad560fe66ee7d139b456451d8aaf7c75a9aaa12007a37f1d6f3056b9   EKSCluster   bad-cluster      0      1      0      0       0      4s
   ```