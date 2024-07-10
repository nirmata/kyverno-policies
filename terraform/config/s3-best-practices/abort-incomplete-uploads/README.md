Amazon S3 supports a bucket lifecycle rule that you can use to direct Amazon S3 to stop multipart uploads that aren't completed within a specified number of days after being initiated. When a multipart upload isn't completed within the specified time frame, it becomes eligible for an abort operation. Amazon S3 then stops the multipart upload and deletes the parts associated with the multipart upload.

You need to make sure that the *lifecycle_configuration* is Enabled and *days_after_initiation* is set to an Integer value. If you don't set an Integer value, NULL value will be considered.

**Test this policy:**

For testing this policy you will need to:
- Make sure you have `nctl` installed on the machine 

1. **Test the Policy with nctl:**
    ```
    nctl scan terraform --resources tf-config.tf --policy policy.yaml
    ```

    a. **Test Policy Against Valid Terraform Config File:**
    ```
    nctl scan terraform --resources test/good-terraform.tf --policies abort-incomplete-uploads.yaml 
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
    | abort-incomplete-uploads | abort-incomplete-uploads | test/good-terraform.tf |         | pass   |
    +--------------------------+--------------------------+------------------------+---------+--------+

    Done
    ```

    b. **Test Against Invalid Terraform Config File:**
    ```
    nctl scan terraform --resources test/bad-terraform-01.tf --policies abort-incomplete-uploads.yaml 
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
    +--------------------------+--------------------------+--------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+--------+
    |          POLICY          |           RULE           |         RESOURCE         |                                                                       MESSAGE                                                                       | RESULT |
    +--------------------------+--------------------------+--------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+--------+
    | abort-incomplete-uploads | abort-incomplete-uploads | test/bad-terraform-01.tf | Set the 'days_after_initiation' argument value to a Positive Integer value in                                                                       | fail   |
    |                          |                          |                          | 'abort_incomplete_multipart_upload' inside the lifecycle configuration block:                                                                       |        |
    |                          |                          |                          | all[1].check.~.(resource.aws_s3_bucket_lifecycle_configuration.values(@)[])[0].~.(rule[?status=='Enabled'])[0].~.(abort_incomplete_multipart_upload |        |
    |                          |                          |                          | || `[{}]`)[0].((days_after_initiation || `-1`) > `0`): Invalid value: false: Expected value: true                                                   |        |
    +--------------------------+--------------------------+--------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+--------+

    Done
    ```

---