# Check RDS Storage Encrypted

This policy checks whether storage encryption is enabled for your Amazon RDS DB instances.
For an added layer of security for your sensitive data in RDS DB instances, you should configure your 
RDS DB instances to be encrypted at rest. To encrypt your RDS DB instances and snapshots at rest, enable the 
encryption option for your RDS DB instances. Data that is encrypted at rest includes the underlying storage 
for DB instances, its automated backups, read replicas, and snapshots. RDS encrypted DB instances use the open 
standard AES-256 encryption algorithm to encrypt your data on the server that hosts your RDS DB instances. 
After your data is encrypted, Amazon RDS handles authentication of access and decryption of your data transparently 
with a minimal impact on performance. You do not need to modify your database client applications to use encryption.
You can read more about it [here](https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-3)

## Policy Details:

- **Policy Name:** check-rds-storage-encrypted
- **Check Description:** This policy ensures that RDS DB instances have encryption at-rest enabled
- **Policy Category:** AWS RDS Best Practices

## Testing Instructions

### Testing with Nirmata Cloud Admission Controller

#### Prerequisites
- AWS CLI properly configured with authentication
- Nirmata Cloud Controller installed and configured

#### Steps to Test

1. **Create RDS Database Instance**
   ```bash
   kubectl apply -f check-rds-storage-encrypted.yaml
   ```

2. **Test Invalid Configuration**
   ```bash
   aws rds create-db-instance \
    --db-instance-identifier storage-not-encrypted \
    --db-instance-class db.t3.micro \
    --engine mysql \
    --master-username admin \
    --master-user-password secret99 \
    --allocated-storage 5 \
    --no-storage-encrypted
   ```
   This will be rejected as storage-encryption is not configured.

3. **Test Valid Configuration**
   ```bash
   aws rds create-db-instance \
    --db-instance-identifier storage-encrypted \
    --db-instance-class db.t3.micro \
    --engine mysql \
    --master-username admin \
    --master-user-password secret99 \
    --allocated-storage 5 \
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
   NAME                                                              KIND            NAME                             PASS   FAIL   WARN   ERROR   SKIP   AGE
   03ed80df0beec13ccccf524793f694a2a2562c21bc1db862ae36c63878b83db   RDSDBInstance   no-multi-az-instance             0      5      0      0       0      2m9s
   1b473e0718e746b0170d2811865094b572a4014dc61321650101b1dacd9aea4   RDSDBInstance   multi-az-instance                1      4      0      0       0      2m9s
   4f4622ce55b0f41e672b37fd33457db24b1fb1a0886bc3381a3431399eb9a54   RDSDBInstance   copy-tags-to-snapshot-enabled    1      4      0      0       0      2m9s
   7e42afc04eccd0678b35941d45e68caeb7ff5ab2365dc804eb654e557473c2a   RDSDBInstance   monitoring-disabled              0      5      0      0       0      2m9s
   91418a86f2fe3c6aaacc2ae9e212172ffa6b59e3bef1d411a71708a5f752746   RDSDBInstance   public-access                    0      5      0      0       0      2m9s
   9db0ac7ef10deba31199236186875050942d412fa7e4d7739a94f67745074a5   RDSDBInstance   no-public-access                 1      4      0      0       0      2m9s
   d5fc6584dbdc7170a4fd1a08575e0a9886f1648f05e3dcd6f7dcdd72b262429   RDSDBInstance   storage-encrypted                1      4      0      0       0      2m8s
   df979cc575131246a5c7a13f368bc2b637e74221c17834d4b856cfa83abedff   RDSDBInstance   copy-tags-to-snapshot-disabled   0      5      0      0       0      2m9s
   e49a73b8361878089f997e226b2b73d89aa1ce19b4174382ac8fea1c924c42f   RDSDBInstance   storage-not-encrypted            0      5      0      0       0      2m8s
   ea25808ff022d1bfa9d2a6e6f9ce8d8b78b2846d89c233e8b7a8b4588f63082   RDSDBInstance   monitoring-enabled               1      4      0      0       0      2m9s

   ```