You can use CloudTrail data events to get information about bucket and object-level requests in Amazon S3. To enable CloudTrail data events for all of your buckets or for a list of specific buckets, you must create a trail manually in CloudTrail.

In your Terraform resource *aws_cloudtrail*, you need to set the value of *enable_logging* to True. This is an optional field and by the default the value is set to True. You can read more about this [here](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail).

**Test this policy:**

For testing this policy you will need to:
- Make sure you have `nctl` installed on the machine 

1. **Test the Policy with nctl:**
    ```
    nctl scan terraform --resources tf-config.tf --policy policy.yaml
    ```

    a. **Test Policy Against Valid Terraform Config File:**
    ```
    nctl scan terraform --resources test/good-terraform-01.tf --policies enable-aws-cloudtrail.yaml 
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
    +-----------------------+------------------------------+---------------------------+---------+--------+
    |        POLICY         |             RULE             |         RESOURCE          | MESSAGE | RESULT |
    +-----------------------+------------------------------+---------------------------+---------+--------+
    | enable-aws-cloudtrail | check-aws-cloudtrail-logging | test/good-terraform-01.tf |         | pass   |
    +-----------------------+------------------------------+---------------------------+---------+--------+

    Done
    ```

    b. **Test Against Invalid Terraform Config File:**
    ```
    nctl scan terraform --resources test/bad-terraform.tf --policies enable-aws-cloudtrail.yaml 
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
    +-----------------------+------------------------------+-----------------------+-----------------------------------------------------------------------------+--------+
    |        POLICY         |             RULE             |       RESOURCE        |                                   MESSAGE                                   | RESULT |
    +-----------------------+------------------------------+-----------------------+-----------------------------------------------------------------------------+--------+
    | enable-aws-cloudtrail | check-aws-cloudtrail-logging | test/bad-terraform.tf | Set the enable_logging argument in aws_cloudtrail resource to true:         | fail   |
    |                       |                              |                       | all[0].check.~.(resource.aws_cloudtrail.values(@)[])[0].(!contains(keys(@), |        |
    |                       |                              |                       | 'enable_logging') || enable_logging == `true`): Invalid value: false:       |        |
    |                       |                              |                       | Expected value: true                                                        |        |
    +-----------------------+------------------------------+-----------------------+-----------------------------------------------------------------------------+--------+

    Done
    ```

---