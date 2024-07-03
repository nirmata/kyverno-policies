Server-side encryption is the encryption of data at its destination by the application or service that receives it. Amazon S3 encrypts your data at the object level as it writes it to disks in AWS data centers and decrypts it for you when you access it. As long as you authenticate your request and you have access permissions, there is no difference in the way you access encrypted or unencrypted objects. For example, if you share your objects by using a presigned URL, that URL works the same way for both encrypted and unencrypted objects. Additionally, when you list objects in your bucket, the list API operations return a list of all objects, regardless of whether they are encrypted.

You have four mutually exclusive options for server-side encryption, depending on how you choose to manage the encryption keys and the number of encryption layers that you want to apply.

1. **Server-side encryption with Amazon S3 managed keys (SSE-S3):** All Amazon S3 buckets have encryption configured by default. The default option for server-side encryption is with Amazon S3 managed keys (SSE-S3). Each object is encrypted with a unique key. As an additional safeguard, SSE-S3 encrypts the key itself with a root key that it regularly rotates. SSE-S3 uses one of the strongest block ciphers available, 256-bit Advanced Encryption Standard (AES-256), to encrypt your data. For more information, see Using server-side encryption with Amazon S3 managed keys (SSE-S3).

2. **Server-side encryption with AWS Key Management Service (AWS KMS) keys (SSE-KMS):** Server-side encryption with AWS KMS keys (SSE-KMS) is provided through an integration of the AWS KMS service with Amazon S3. With AWS KMS, you have more control over your keys. For example, you can view separate keys, edit control policies, and follow the keys in AWS CloudTrail. Additionally, you can create and manage customer managed keys or use AWS managed keys that are unique to you, your service, and your Region. For more information, see Using server-side encryption with AWS KMS keys (SSE-KMS).

3. **Dual-layer server-side encryption with AWS Key Management Service (AWS KMS) keys (DSSE-KMS):** Dual-layer server-side encryption with AWS KMS keys (DSSE-KMS) is similar to SSE-KMS, but DSSE-KMS applies two individual layers of object-level encryption instead of one layer. Because both layers of encryption are applied to an object on the server side, you can use a wide range of AWS services and tools to analyze data in S3 while using an encryption method that can satisfy your compliance requirements. For more information, see Using dual-layer server-side encryption with AWS KMS keys (DSSE-KMS).

4. **Server-side encryption with customer-provided keys (SSE-C):** With server-side encryption with customer-provided keys (SSE-C), you manage the encryption keys, and Amazon S3 manages the encryption as it writes to disks and the decryption when you access your objects. For more information, see Using server-side encryption with customer-provided keys (SSE-C).

It is important to note that the *sse_algorithm* is the field in the terraform file that will determine what type of encryption will be applied to S3. By default, if you don't specify any value or don't use the block, *sse_algorithm* will be set to *AES256*. You can read more about the *aws_s3_bucket_server_side_encryption_configuration* block [here](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration).

### Policy Validation Testing Instructions

For testing this policy you will need to:
- Make sure you have `nctl` installed on the machine 

1. **Test the Policy with nctl:**
    ```
    nctl scan terraform --resources tf-config.tf --policy policy.yaml
    ```

    a. **Test Policy Against Valid Terraform Config File:**
    ```
    nctl scan terraform --resources test/good-terraform.tf --policies enable-kms-encryption.yaml 
    ```

    This produces the output:
    ```
    Version: 4.0.1
    Fetching policies...
    Loading policies...
    • found 1 policies
    Running analysis...
    • no errors
    Results...
    +--------------------------+--------------------------+------------------------+---------+--------+
    |          POLICY          |           RULE           |        RESOURCE        | MESSAGE | RESULT |
    +--------------------------+--------------------------+------------------------+---------+--------+
    | s3-enable-kms-encryption | check-encryption-setting | test/good-terraform.tf |         | pass   |
    +--------------------------+--------------------------+------------------------+---------+--------+
 
    Done
    ```

    b. **Test Against Invalid Terraform Config File:**
    ```
    nctl scan terraform --resources test/bad-terraform-01.tf --policies enable-kms-encryption.yaml 
    ```

    This produces the output:
    ```
    Version: 4.0.1
    Fetching policies...
    Loading policies...
    • found 1 policies
    Running analysis...
    • no errors
    Results...
    +--------------------------+--------------------------+-------------------------- +----------------------------------------------------------------------------------------------------------------------------------------------------+--------+
    |          POLICY          |           RULE           |         RESOURCE         |                                                                       MESSAGE                                                                       | RESULT |
    +--------------------------+--------------------------+-------------------------- +----------------------------------------------------------------------------------------------------------------------------------------------------+--------+
    | s3-enable-kms-encryption | check-encryption-setting | test/bad-terraform-01.tf | S3 server side encryption is not set to  KMS:                                                                                                       | fail   |
    |                          |                          |                          | all[0].check.~.(resource.aws_s3_bucket_server_side_encryption_configuration.values(@)[])[0].~.(rule)[0].~. (apply_server_side_encryption_by_default |        |
    |                          |                          |                          | || `[{}]`)[0].(sse_algorithm == 'aws:kms'): Invalid value: false: Expected value:  true                                                             |        |
    +--------------------------+--------------------------+-------------------------- +----------------------------------------------------------------------------------------------------------------------------------------------------+--------+
 
    Done
    ```

---