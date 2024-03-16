To manage your objects so that they are stored cost effectively throughout their lifecycle, configure their Amazon S3 Lifecycle. An S3 Lifecycle configuration is a set of rules that define actions that Amazon S3 applies to a group of objects. There are two types of actions:

- **Transition actions** – These actions define when objects transition to another storage class. For example, you might choose to transition objects to the S3 Standard-IA storage class 30 days after creating them, or archive objects to the S3 Glacier Flexible Retrieval storage class one year after creating them. 

There are costs associated with lifecycle transition requests. For pricing information, see Amazon S3 pricing.

- **Expiration actions** – These actions define when objects expire. Amazon S3 deletes expired objects on your behalf.

Lifecycle expiration costs depend on when you choose to expire objects. For more information, see Expiring objects.

In order to set lifecycle configurationaws_s3_bucket_lifecycle_configuration using Terraform, you need to use the [aws_s3_bucket_versioning block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) in your Terraform and set the value for *Status* field to *Enabled* in order to enable *lifecycle configuration*. By default, the field is set to *Disabled*. This means that if you don't specify this block in your Terraform file, the *lifecycle configuration* will be *Disabled* by default. It is mandatory to specify the *aws_s3_bucket_lifecycle_configuration* block. Also *Status* field is mandatory to be set and if you're using the *aws_s3_bucket_lifecycle_configuration* block, you can't comment any field.

In order to test this policy, use the following commands:

1. Navigate to the `aws/s3/terraform/enable-lifecycle-configuration` directory. All the payloads along with Terraform files are present in the `test` directory.

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
   kyverno-json scan --payload good-payload.json --policy enable-lifecycle-configuration.yaml
   ```
   Since you've set the value of *Status* field to *Enabled*, the policy will give you PASS checks. If you try to modify this value (say Disabled), get the new payload again, and test it again using the above command, you'll get FAIL checks. You can also modify your Terraform file to exclude that block and get a new payload. When you try to scan for a payload that has come from a Terraform file for which the *aws_s3_bucket_lifecycle_configuration* block has not been specified, the policy will give you failing checks since the default value is *Disabled*.
   