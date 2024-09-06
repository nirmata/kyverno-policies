Amazon S3 supports a bucket lifecycle rule that you can use to direct Amazon S3 to stop multipart uploads that aren't completed within a specified number of days after being initiated. When a multipart upload isn't completed within the specified time frame, it becomes eligible for an abort operation. Amazon S3 then stops the multipart upload and deletes the parts associated with the multipart upload.

You need to make sure that the *lifecycle_configuration* is Enabled and *days_after_initiation* is set to an Integer value. If you don't set an Integer value, NULL value will be considered.

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
   kyverno-json scan --payload payload.json --policy policy.yaml --bindings ./binding.yaml
   ```
   Since you've set the `Status` field to `Enabled` in *good-terraform.tf* file and *days_after_initiation* argument inside the *abort_incomplete_multipart_upload* set to an Positive Integer value, the policy will give you Passing checks. If you try to change the value of `Status` to *Disabled* or *days_after_initiation* to *NULL* value, the policy will give you failing checks.

   In case you'd like to test this policy for a failing scneario, try to set the payload to `./aws/disable-s3-acl/test/bad-payload-01.json` and run the `kyverno-json scan` command again.