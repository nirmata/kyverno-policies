Amazon S3 Block Public Access provides settings for access points, buckets, and accounts to help you manage public access to Amazon S3 resources. By default, new buckets, access points, and objects do not allow public access.

In order to configure public block access settings for your S3 buckets, read [here](https://docs.aws.amazon.com/AmazonS3/latest/userguide/configuring-block-public-access-bucket.html)

S3 Block Public Access provides four settings. You can apply these settings in any combination to individual access points, buckets, or entire AWS accounts. If you apply a setting to an account, it applies to all buckets and access points that are owned by that account. Similarly, if you apply a setting to a bucket, it applies to all access points associated with that bucket.

The four settings mentioned above are:

1. *BlockPublicAcls*: When this is turned on, it prevents anyone from making data in a  bucket public by using Access Control Lists (ACLs). ACLs are like a list of who can and cannot access stuff in the bucket.
   
2. *IgnorePublicAcls*: If this is enabled, it means the system ignores any public access settings set by Access Control Lists (ACLs). In simpler terms, it doesn't pay attention to certain rules that might make data public.
   
3. *BlockPublicPolicy*: This setting stops people from making data public by using bucket policies. Bucket policies are like rules you set for who can access your bucket and how. When you enable this, it prevents public access through these policies.
   
4. *RestrictPublicBuckets*: Turning this on limits public access to buckets. It means you're putting restrictions on making your buckets and the data inside them public. This helps in adding an extra layer of control to prevent accidental exposure of your data to the public.
   
A brief details about these options have been mentioned in the [AWS Documentation](https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html).

Now, if you'd like to disable the public access block for your S3 bucket, you need to make sure that all the above four settings are enabled. Terraform provides you the `aws_s3_bucket_public_access_block` resource to configure these settings

```
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
```

**It is important to note that all the argument should be set to *true* in order to disable the public access control. If any one of the argument is set to false, there will be public access configured based on the above settings defined.**

If you'd like to learn more about this, head over to the [Argument Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block#argument-reference) for public access block in Terraform.

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

   Since you've set all the fields for S3 public access block in your Terraform file to *true*, the policy will give you *Passing checks*. 

**Failing Scenario:** If you set any of the argument in your Terraform S3 public access block to false, the policy will be failed. Why? Because you are trying to enable the public access block. A Terraform S3 public access block that could give failing scenario is given below:

```
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example.id

  block_public_acls       = false
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = false
}
```

Ideally, you can test your policy for the *bad-payload.json* that is present at `./aws/s3/public-access-block/policy-test` using the following command from root:

```
kyverno-json scan --payload ./aws/s3/public-access-block/policy-test/bad-payload.json --policy policy.yaml
```

There is also `bad-s3.tf` file provided under `policy-test` directory that you can use to build your payload and use in the above command as an argument to `--policy` flag.