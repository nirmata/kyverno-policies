Replication enables automatic, asynchronous copying of objects across Amazon S3 buckets. Buckets that are configured for object replication can be owned by the same AWS account or by different accounts. You can replicate objects to a single destination bucket or to multiple destination buckets. The destination buckets can be in different AWS Regions or within the same Region as the source bucket. 

To automatically replicate new objects as they are written to the bucket, use live replication, such as Cross-Region Replication (CRR). To replicate existing objects to a different bucket on demand, use S3 Batch Replication.

In order to *Enable* the cross-region replication for an S3 Bucket, you need to use the *aws_s3_bucket_replication_configuration* resource block in your Terraform file. The *status* field which is a mandatory field will determine whether you'd like to enable the Cross Region Replication or not. The required values for *Status* are *Enabled* or *Disabled* which means you can neither set any other value (say foo) for status field nor exclude the status field from your resource block. You can read more about this in [Terraform documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_replication_configuration#status).

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
   kyverno-json scan --payload good-payload.json --policy s3-cross-region-replication.yaml --bindings ./binding.yaml
   ```
   Since you've set the `status` field to `Enabled` in *good-terraform.tf* file, the policy will give you Passing checks. If you try to change the value of `status` to  `Disabled` the policy will give you failing checks on a the new payload. 
   
In case you'd like to test this policy for a failing scneario, try to set the payload to `./aws/enable-s3-cross-region-replication/test/bad-payload.json` and run the `kyverno-json scan` command again.