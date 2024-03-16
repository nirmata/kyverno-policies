The Access Control List (ACL) by default is disabled for an S3 Bucket. However, if you'd like to disable the ACL while creating an S3 Bucket from a Terraform file, there are three options that you can provide to the `object_ownership` field in your Terraform file. 

**ACLs disabled**:
- *Bucket owner enforced (default)* – ACLs are disabled, and the bucket owner automatically owns and has full control over every object in the bucket. ACLs no longer affect permissions to data in the S3 bucket. The bucket uses policies to define access control.

**ACLs enabled**:
- *Bucket owner preferred* – The bucket owner owns and has full control over new objects that other accounts write to the bucket with the bucket-owner-full-control canned ACL.

- *Object writer* – The AWS account that uploads an object owns the object, has full control over it, and can grant other users access to it through ACLs.

You can read more information about  [Controlling ownership of objects and disabling ACLs for your bucket](https://docs.aws.amazon.com/AmazonS3/latest/userguide/about-object-ownership.html?icmpid=docs_amazons3_console).

In order to test this policy, use the following commands:

1. Initialise Terraform in your working directory
    ```
    terraform init
    ```

2. Create a binary of your terraform plan
    ```
    terraform plan -out tfplan.binary
    ```

3. Convert the executable binary into JSON Payload
   ```
   terraform show -json tfplan.binary | jq > payload.json
   ```
4. Test the policy using `kyverno-json` command
   ```
   kyverno-json scan --payload payload.json --policy policy.yaml 
   ```
   Since you've set the `object_ownership` field to `BucketOwnerEnforced` in *s3-disable.tf* file, the policy will give you Passing checks. If you try to change the value of `object_ownership` to either `BucketOwnerPreferred` or `ObjectWriter` the policy will give you failing checks.

   In case you'd like to test this policy for a failing scneario, try to set the payload to `./aws/disable-s3-acl/policy-test/bad-payload.json` and run the `kyverno-json scan` command again.