The Access Control List (ACL) by default is disabled for an S3 Bucket. However, if you'd like to disable the ACL while creating an S3 Bucket from a Terraform file, there are three options that you can provide to the `object_ownership` field in your Terraform file. 

**ACLs disabled**:
- *Bucket owner enforced (default)* – ACLs are disabled, and the bucket owner automatically owns and has full control over every object in the bucket. ACLs no longer affect permissions to data in the S3 bucket. The bucket uses policies to define access control.

**ACLs enabled**:
- *Bucket owner preferred* – The bucket owner owns and has full control over new objects that other accounts write to the bucket with the bucket-owner-full-control canned ACL.

- *Object writer* – The AWS account that uploads an object owns the object, has full control over it, and can grant other users access to it through ACLs.

You can read more information about  [Controlling ownership of objects and disabling ACLs for your bucket](https://docs.aws.amazon.com/AmazonS3/latest/userguide/about-object-ownership.html?icmpid=docs_amazons3_console).

**Test this policy:**

For testing this policy you will need to:
- Make sure you have `nctl` installed on the machine 

1. **Test the Policy with nctl:**
    ```
    nctl scan terraform --resources tf-config.tf --policy policy.yaml
    ```

    a. **Test Policy Against Valid Terraform Config File:**
    ```
    nctl scan terraform --resources test/good-terraform.tf --policies disable-s3-acl.yaml 
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
    +--------------------------------+--------------------------------+------------------------+---------+--------+
    |             POLICY             |              RULE              |        RESOURCE        | MESSAGE | RESULT |
    +--------------------------------+--------------------------------+------------------------+---------+--------+
    | disable-s3-access-control-list | disable-s3-access-control-list | test/good-terraform.tf |         | pass   |
    +--------------------------------+--------------------------------+------------------------+---------+--------+

    Done
    ```

    b. **Test Against Invalid Terraform Config File:**
    ```
    nctl scan terraform --resources test/bad-terraform.tf --policies disable-s3-acl.yaml 
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
    +--------------------------------+--------------------------------+-----------------------+---------------------------------------------------------------------------------------------------------+--------+
    |             POLICY             |              RULE              |       RESOURCE        |                                                 MESSAGE                                                 | RESULT |
    +--------------------------------+--------------------------------+-----------------------+---------------------------------------------------------------------------------------------------------+--------+
    | disable-s3-access-control-list | disable-s3-access-control-list | test/bad-terraform.tf | Access Control List(ACL) should be disabled for an S3 Bucket:                                           | fail   |
    |                                |                                |                       | all[0].check.~.(resource.aws_s3_bucket_ownership_controls.values(@)[])[0].~.(rule)[0].object_ownership: |        |
    |                                |                                |                       | Invalid value: "ObjectWriter": Expected value: "BucketOwnerEnforced"                                    |        |
    +--------------------------------+--------------------------------+-----------------------+---------------------------------------------------------------------------------------------------------+--------+

    Done
    ```

---