# Check RDS Cluster Encrypted At Rest

This policy checks if an RDS DB cluster is encrypted at rest. The policy fails if an RDS DB cluster isn't encrypted at rest.
Data at rest refers to any data that's stored in persistent, non-volatile storage for any duration. 
Encryption helps you protect the confidentiality of such data, reducing the risk that an unauthorized user can access it. 
Encrypting your RDS DB clusters protects your data and metadata against unauthorized access. 
It also fulfills compliance requirements for data-at-rest encryption of production file systems.
You can read more about it [here](https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-27)

## Policy Details:

- **Policy Name:** check-rds-cluster-encrypted-at-rest
- **Check Description:** This policy ensures that RDS DB Clusters have encryption at-rest enabled
- **Policy Category:** AWS RDS Best Practices

## Testing Instructions

### Testing with Nirmata Cloud Admission Controller

#### Prerequisites
- AWS CLI properly configured with authentication
- Nirmata Cloud Controller installed and configured

#### Steps to Test

1. **Create Policy in the Cluster**
   ```bash
   kubectl apply -f check-rds-cluster-encrypted-at-rest.yaml
   ```

2. **Test Invalid Configuration**
   ```bash
   aws rds create-db-cluster \
    --db-cluster-identifier cluster-storage-not-encrypted \
    --engine aurora-mysql \
    --master-username admin \
    --master-user-password admin123 \
    --no-storage-encrypted
   ```
   This will be rejected as storage-encrypted is not configured.

3. **Test Valid Configuration**
   ```bash
   aws rds create-db-cluster \
    --db-cluster-identifier cluster-storage-encrypted \
    --engine aurora-mysql \
    --master-username admin \
    --master-user-password admin123 \
    --storage-encrypted
   ```

### Testing with Nirmata Cloud Scanner

1. Ensure the Cloud Scanner Pod is running with required credentials.

2. Create test clusters using the commands above.

3. Check cluster policy reports:
   ```bash
   kubectl get clusterpolicyreports
   ```

   Example output:
   ```
   NAME                                                              KIND           NAME                            PASS   FAIL   WARN   ERROR   SKIP   AGE
   2165005f4a7343d37e1aa287232a6e1fc25616db9f396f9955b37b6dfb9ad50   RDSDBCluster   cluster-storage-encrypted       1      1      0      0       0      2m49s
   b970d93cf2d4a4b35b2a422ad75677d9d22d03a476f0f72795035d7b6d1dd62   RDSDBCluster   deletion-protection-disabled    0      2      0      0       0      2m49s
   e7d4b334553a6a78695cf3ce1f0fcc62e21bffe1b56d868644b82d9371b7925   RDSDBCluster   cluster-storage-not-encrypted   0      2      0      0       0      2m49s
   f9a505915d775bbabb3038f79aa1f5d94121ebb93b06a829816f19b236b0c7d   RDSDBCluster   deletion-protection-enabled     1      1      0      0       0      2m49s

   ```