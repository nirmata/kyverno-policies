# Check RDS DB Proxy TLS

RDS Proxy can use security mechanisms such as TLS to add an additional layer of security between client applications and the underlying database. 
Database connections often involve sensitive information, such as personally identifiable information (PII), financial data, or confidential business data. 
Protecting this data in transit is important to maintain security of the data.
This policy checks if the RDS Proxy is using TLS.

## Policy Details:

- **Policy Name:** check-rds-db-proxy-tls
- **Check Description:** This policy ensures that RDS Proxies use TLS
- **Policy Category:** AWS RDS Best Practices

## Testing Instructions

### Testing with Nirmata Cloud Admission Controller

#### Prerequisites
- AWS CLI properly configured with authentication
- Nirmata Cloud Controller installed and configured

#### Steps to Test

1. **Create RDS Database Proxy**
   ```bash
   kubectl apply -f check-rds-db-proxy-tls.yaml
   ```

2. **Test Invalid Configuration**
   ```bash
   aws rds create-db-proxy \
    --db-proxy-name bad-db-proxy-01 \
    --engine-family POSTGRESQL \
    --auth 'AuthScheme=SECRETS,SecretArn=arn:aws:secretsmanager:ap-south-1:xxxxx:secret:demo/secret/rds-peBhuC' \
    --role-arn arn:aws:iam::xxxxx:role/aws-service-role/rds.amazonaws.com/AWSServiceRoleForRDS \
    --vpc-subnet-ids subnet-id-1 subnet-id-2 \
    --no-require-tls
   ```
   This will be rejected as require-tls is not configured.

3. **Test Valid Configuration**
   ```bash
   aws rds create-db-proxy \
    --db-proxy-name good-db-proxy-01 \
    --engine-family POSTGRESQL \
    --auth 'AuthScheme=SECRETS,SecretArn=arn:aws:secretsmanager:ap-south-1:xxxxx:secret:demo/secret/rds-peBhuC' \
    --role-arn arn:aws:iam::xxxxx:role/aws-service-role/rds.amazonaws.com/AWSServiceRoleForRDS \
    --vpc-subnet-ids subnet-id-1 subnet-id-2 \
    --require-tls
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
   NAME                                                              KIND         NAME               PASS   FAIL   WARN   ERROR   SKIP   AGE
   1d08484d06efe92ff5a42b1b52d2d9aaef571375cbd5d845b7233bfe4f3b28b   RDSDBProxy   bad-db-proxy-01    0      1      0      0       0      2s
   fce926ed5eb866239dc823d359cd07d767a04cd669b4104e511fadcc338dd78   RDSDBProxy   good-db-proxy-01   1      0      0      0       0      2s
   ```