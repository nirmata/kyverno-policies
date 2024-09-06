Versioning in Amazon S3 is a means of keeping multiple variants of an object in the same bucket. You can use the S3 Versioning feature to preserve, retrieve, and restore every version of every object stored in your buckets. With versioning you can recover more easily from both unintended user actions and application failures. After versioning is enabled for a bucket, if Amazon S3 receives multiple write requests for the same object simultaneously, it stores all of those objects.

Versioning-enabled buckets can help you recover objects from accidental deletion or overwrite. For example, if you delete an object, Amazon S3 inserts a delete marker instead of removing the object permanently. The delete marker becomes the current object version. If you overwrite an object, it results in a new object version in the bucket. You can always restore the previous version. For more information, see Deleting object versions from a versioning-enabled bucket.

By default, S3 Versioning is disabled on buckets, and you must explicitly enable it. Buckets can be in one of three states:

- Unversioned (the default)

- Versioning-enabled

- Versioning-suspended

You enable and suspend versioning at the bucket level. After you version-enable a bucket, it can never return to an unversioned state. But you can suspend versioning on that bucket.

The versioning state applies to all (never some) of the objects in that bucket. When you enable versioning in a bucket, all new objects are versioned and given a unique version ID. Objects that already existed in the bucket at the time versioning was enabled will thereafter always be versioned and given a unique version ID when they are modified by future requests. Note the following:

- Objects that are stored in your bucket before you set the versioning state have a version ID of null. When you enable versioning, existing objects in your bucket do not change. What changes is how Amazon S3 handles the objects in future requests.

- The bucket owner (or any user with appropriate permissions) can suspend versioning to stop accruing object versions. When you suspend versioning, existing objects in your bucket do not change. What changes is how Amazon S3 handles objects in future requests. 

In order to set versioning using Terraform, you need to use the  [aws_s3_bucket_versioning block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning#versioning_configuration) in your Terraform and set the value for *status* field to *Enabled* in order to enable versioning. By default, the field is set to *Disabled*. This means that if you don't specify this block in your Terraform file, the versioning will be *Disabled* by default. 

In order to test this policy, use the following commands:

1. Navigate to the `aws/s3/terraform/enable-s3-versioning` directory. All the payloads along with Terraform files are present in the `test` directory.

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
   kyverno-json scan --payload payload.json --policy enable-kms-encryption.yaml --bindings ./binding.yaml
   ```
   Since you've set the value of *status* field to *Enabled*, the policy will give you PASS checks. If you try to modify this value (say foo), get the new payload again, and test it again using the above command, you'll get FAIL checks. You can also modify your Terraform file to exclude that block and get a new payload. When you try to scan for a payload that has come from a Terraform file for which the *aws_s3_bucket_versioning block* block has not been specified, the policy will give you failing checks since the default value is *Disabled*.