Server-side encryption is the encryption of data at its destination by the application or service that receives it. Amazon S3 encrypts your data at the object level as it writes it to disks in AWS data centers and decrypts it for you when you access it. As long as you authenticate your request and you have access permissions, there is no difference in the way you access encrypted or unencrypted objects. For example, if you share your objects by using a presigned URL, that URL works the same way for both encrypted and unencrypted objects. Additionally, when you list objects in your bucket, the list API operations return a list of all objects, regardless of whether they are encrypted.

You have four mutually exclusive options for server-side encryption, depending on how you choose to manage the encryption keys and the number of encryption layers that you want to apply.

1. **Server-side encryption with Amazon S3 managed keys (SSE-S3):** All Amazon S3 buckets have encryption configured by default. The default option for server-side encryption is with Amazon S3 managed keys (SSE-S3). Each object is encrypted with a unique key. As an additional safeguard, SSE-S3 encrypts the key itself with a root key that it regularly rotates. SSE-S3 uses one of the strongest block ciphers available, 256-bit Advanced Encryption Standard (AES-256), to encrypt your data. For more information, see Using server-side encryption with Amazon S3 managed keys (SSE-S3).

2. **Server-side encryption with AWS Key Management Service (AWS KMS) keys (SSE-KMS):** Server-side encryption with AWS KMS keys (SSE-KMS) is provided through an integration of the AWS KMS service with Amazon S3. With AWS KMS, you have more control over your keys. For example, you can view separate keys, edit control policies, and follow the keys in AWS CloudTrail. Additionally, you can create and manage customer managed keys or use AWS managed keys that are unique to you, your service, and your Region. For more information, see Using server-side encryption with AWS KMS keys (SSE-KMS).

3. **Dual-layer server-side encryption with AWS Key Management Service (AWS KMS) keys (DSSE-KMS):** Dual-layer server-side encryption with AWS KMS keys (DSSE-KMS) is similar to SSE-KMS, but DSSE-KMS applies two individual layers of object-level encryption instead of one layer. Because both layers of encryption are applied to an object on the server side, you can use a wide range of AWS services and tools to analyze data in S3 while using an encryption method that can satisfy your compliance requirements. For more information, see Using dual-layer server-side encryption with AWS KMS keys (DSSE-KMS).

4. **Server-side encryption with customer-provided keys (SSE-C):** With server-side encryption with customer-provided keys (SSE-C), you manage the encryption keys, and Amazon S3 manages the encryption as it writes to disks and the decryption when you access your objects. For more information, see Using server-side encryption with customer-provided keys (SSE-C).

It is important to note that the *sse_algorithm* is the field in the terraform file that will determine what type of encryption will be applied to S3. By default, if you don't specify any value or don't use the block, *sse_algorithm* will be set to *AES256*. You can read more about the *aws_s3_bucket_server_side_encryption_configuration* block [here](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration).

In order to test this policy, use the following commands:

1. Navigate to the `aws/s3/terraform/enable-kms-encryption` directory. All the payloads along with Terraform files are present in the `test` directory.
   
2. Assume you're trying to get the payload using the *good-terraform.tf* file, use the following commands:
   ```
   terraform plan -out tfplan.binary
   ```
3. Convert this binary into JSON payload using `terraform show` command
   ```
   terraform show -json tfplan.binary | jq > payload.json
   ```
4. Test your payload against the policy using `kyverno-json scan` command
   ```
   kyverno-json scan --payload payload.json --policy enable-kms-encryption.yaml
   ```
   Since you've set the value of *sse_algorithm* to *aws:kms*, the policy will give you PASS checks. If you try to modify this value (say foo), get the new payload again, and test it again using the above command, you'll get FAIL checks.