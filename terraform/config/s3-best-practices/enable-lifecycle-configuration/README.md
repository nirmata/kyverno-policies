To manage your objects so that they are stored cost effectively throughout their lifecycle, configure their Amazon S3 Lifecycle. An S3 Lifecycle configuration is a set of rules that define actions that Amazon S3 applies to a group of objects. There are two types of actions:

- **Transition actions** – These actions define when objects transition to another storage class. For example, you might choose to transition objects to the S3 Standard-IA storage class 30 days after creating them, or archive objects to the S3 Glacier Flexible Retrieval storage class one year after creating them. 

There are costs associated with lifecycle transition requests. For pricing information, see Amazon S3 pricing.

- **Expiration actions** – These actions define when objects expire. Amazon S3 deletes expired objects on your behalf.

Lifecycle expiration costs depend on when you choose to expire objects. For more information, see Expiring objects.

In order to set lifecycle configurationaws_s3_bucket_lifecycle_configuration using Terraform, you need to use the [aws_s3_bucket_versioning block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) in your Terraform and set the value for *Status* field to *Enabled* in order to enable *lifecycle configuration*. By default, the field is set to *Disabled*. This means that if you don't specify this block in your Terraform file, the *lifecycle configuration* will be *Disabled* by default. It is mandatory to specify the *aws_s3_bucket_lifecycle_configuration* block. Also *Status* field is mandatory to be set and if you're using the *aws_s3_bucket_lifecycle_configuration* block, you can't comment any field.

**Test this policy:**

For testing this policy you will need to:
- Make sure you have `nctl` installed on the machine 

1. **Test the Policy with nctl:**
    ```
    nctl scan terraform --resources tf-config.tf --policy policy.yaml
    ```

    a. **Test Policy Against Valid Terraform Config File:**
    ```
    nctl scan terraform --resources test/good-terraform.tf --policies enable-lifecycle-configuration.yaml 
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
    +----------------------------+----------------------------------+------------------------+---------+--------+
    |           POLICY           |               RULE               |        RESOURCE        | MESSAGE | RESULT |
    +----------------------------+----------------------------------+------------------------+---------+--------+
    | s3-lifecycle-configuration | check-s3-lifecycle-configuration | test/good-terraform.tf |         | pass   |
    +----------------------------+----------------------------------+------------------------+---------+--------+

    Done
    ```

    b. **Test Against Invalid Terraform Config File:**
    ```
    nctl scan terraform --resources test/bad-terraform-01.tf --policies enable-lifecycle-configuration.yaml 
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
    +----------------------------+----------------------------------+--------------------------+---------------------------------------------------------------------------------------------------- +--------+
    |           POLICY           |               RULE               |         RESOURCE         |                                              MESSAGE                                               |  RESULT |
    +----------------------------+----------------------------------+--------------------------+---------------------------------------------------------------------------------------------------- +--------+
    | s3-lifecycle-configuration | check-s3-lifecycle-configuration | test/bad-terraform-01.tf | S3 Bucket Lifecycle Configuration 'status' needs to be set to 'Enabled':                           |  fail   |
    |                            |                                  |                          | all[0].check.~.(resource.aws_s3_bucket_lifecycle_configuration.values(@)[])[0].~.(rule)[0]. status: |        |
    |                            |                                  |                          | Invalid value: "Disabled": Expected value:  "Enabled"                                               |        |
    +----------------------------+----------------------------------+--------------------------+---------------------------------------------------------------------------------------------------- +--------+
 
    Done
    ```

---