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

### Policy Validation Testing Instructions

For testing this policy you will need to:
- Make sure you have `kyverno-json` installed on the machine 
- Properly authenticate with AWS

1. **Create the RDS Database Instance:**

    a. Good RDS Database Instance
    ```bash
    aws rds create-db-instance \
    --db-instance-identifier good-mysql-instance \
    --db-instance-class db.t3.micro \
    --engine mysql \
    --master-username admin \
    --master-user-password secret99 \
    --allocated-storage 5 \
    --storage-encrypted
    ```

    b. Bad RDS Database Instance
    ```bash
    aws rds create-db-instance \
    --db-instance-identifier bad-mysql-instance-01 \
    --db-instance-class db.t3.micro \
    --engine mysql \
    --master-username admin \
    --master-user-password secret99 \
    --allocated-storage 5 \
    --no-storage-encrypted
    ```

2. **Get the Payloads:**

    a. Bad Payload
    ```bash
    aws rds describe-db-instances --db-instance-identifier bad-mysql-instance-01 > bad-payload-01.json
    ```

    b. Good Payload
    ```bash
    aws rds describe-db-instances --db-instance-identifier good-mysql-instance > good-payload-01.json
    ```
3. **Clean Up Resources:**

    a. Delete the Bad RDS Instance
    ```bash
    aws rds delete-db-instance --db-instance-identifier bad-mysql-instance-01 --skip-final-snapshot 
    ```

    b. Delete the Good RDS Instance

    ```bash
    aws rds delete-db-instance --db-instance-identifier good-mysql-instance --skip-final-snapshot 
    ```

4. **Test the Policy with Kyverno:**
    ```
    kyverno-json scan --payload payload.json --policy policy.yaml
    ```

    a. **Test Policy Against Valid Payload:**
    ```
    kyverno-json scan --payload test/good-test/good-payload-01.json --policy check-rds-storage-encrypted.yaml 
    ```

    This produces the output:
    ```bash
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - check-rds-storage-encrypted / check-rds-storage-encrypted /  PASSED
    Done
    ```

    b. **Test Against Invalid Payload:**
    ```bash
    kyverno-json scan --payload test/bad-test/bad-payload-01.json --policy check-rds-storage-encrypted.yaml 
    ```

    This produces the output:
    ```bash
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - check-rds-storage-encrypted / check-rds-storage-encrypted /  FAILED
    -> RDS DB instances should have encryption at-rest enabled
    -> all[0].check.~.(DBInstances)[0].StorageEncrypted: Invalid value: false: Expected value: true
    Done
    ```