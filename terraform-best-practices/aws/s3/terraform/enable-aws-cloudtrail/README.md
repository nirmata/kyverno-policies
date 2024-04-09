You can use CloudTrail data events to get information about bucket and object-level requests in Amazon S3. To enable CloudTrail data events for all of your buckets or for a list of specific buckets, you must create a trail manually in CloudTrail.

In your Terraform resource *aws_cloudtrail*, you need to set the value of *enable_logging* to True. This is an optional field and by the default the value is set to True. You can read more about this [here](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail).

**Test this policy:**

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
   kyverno-json scan --payload good-payload.json --policy enable-aws-cloudtrail.yaml 
   ```
   Since you've set the `enable_logging` field to `True` in *good-terraform.tf* file, the policy will give you Passing checks. If you try to change the value of `enable_logging` to  `False` the policy will give you failing checks on a the new payload. 
   
In case you'd like to test this policy for a failing scneario, try to set the payload to `./aws/enable-aws-coudtrain/test/bad-payload.json` and run the `kyverno-json scan` command again.