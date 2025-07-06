# Check RDS Cluster Deletion Protection Enabled

Preventing accidental deletion of an RDS database through the AWS Management Console, AWS CLI, or the RDS API is essential for avoiding data loss. 
The database can't be deleted when deletion protection is enabled. This ensures an extra layer of protection for your data, preventing 
unintended actions from impacting availability or causing data loss. By enabling deletion protection, you ensure that the database 
remains intact until deliberate action is taken to disable this setting.

## Policy Details:

- **Policy Name:** check-rds-cluster-deletion-protection-enabled
- **Check Description:** This policy ensures that deletion protection is enabled for RDS databases
- **Policy Category:** AWS RDS Best Practices

## Testing Instructions

### Testing with Nirmata Cloud Admission Controller

#### Prerequisites
- AWS CLI properly configured with authentication
- Nirmata Cloud Controller installed and configured

#### Steps to Test

1. **Create Policy in the Cluster**
   ```bash
   kubectl apply -f check-rds-cluster-deletion-protection-enabled.yaml
   ```

2. **Test Invalid Configuration**
   ```bash
   aws rds create-db-cluster \
    --db-cluster-identifier deletion-protection-disabled \
    --engine aurora-mysql \
    --master-username admin \
    --master-user-password admin123
   ```
   This will be rejected as deletion-protection is not configured.

3. **Test Valid Configuration**
   ```bash
   aws rds create-db-cluster \
    --db-cluster-identifier deletion-protection-enabled \
    --engine aurora-mysql \
    --master-username admin \
    --master-user-password admin123 \
    --deletion-protection
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