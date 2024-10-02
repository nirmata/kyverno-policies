# Check EC2 Detailed Monitoring

CloudWatch provides two categories of monitoring: basic monitoring and detailed monitoring.
By default, an instance is enabled for basic monitoring and metrics is published at five-minute intervals. Amazon EC2 detailed monitoring provides more frequent metrics, published at one-minute intervals. Using detailed monitoring for Amazon EC2 helps you better manage your Amazon EC2 resources, so that you can find trends and take action faster. However, enabling detailed monitoring incurs additional [charges](https://aws.amazon.com/cloudwatch/pricing/).

You can read more about it [here](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-cloudwatch-new.html)

## Policy Details:

- **Policy Name:** check-ec2-detailed-monitoring
- **Check Description:** This policy ensures that detailed monitoring is enabled for the EC2 instance
- **Policy Category:** AWS EC2 Best Practices

### Policy Validation Testing Instructions

For testing this policy you will need to:
- Make sure you have `kyverno-json` installed on the machine 
- Properly authenticate with AWS

1. **Initialize Terraform:**
    ```bash
    terraform init
    ```

2. **Create Binary Terraform Plan:**
    ```bash
    terraform plan -out tfplan.binary
    ```

3. **Convert Binary to JSON Payload:**
    ```bash
    terraform show -json tfplan.binary | jq > payload.json
    ```

4. **Test the Policy with Kyverno:**
    ```
    kyverno-json scan --payload payload.json --policy policy.yaml
    ```

    a. **Test Policy Against Valid Payload:**
    ```
    kyverno-json scan --payload test/good-test/good-payload-01.json --policy check-ec2-detailed-monitoring.yaml 
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - check-ec2-detailed-monitoring / check-ec2-detailed-monitoring /  PASSED
    Done
    ```

    b. **Test Against Invalid Payload:**
    ```
    kyverno-json scan --payload test/bad-test/bad-payload-01.json --policy check-ec2-detailed-monitoring.yaml 
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - check-ec2-detailed-monitoring / check-ec2-detailed-monitoring /  FAILED
    -> Detailed monitoring must be enabled for the EC2 instance
    -> all[0].check.~.(planned_values.root_module.resources[?type=='aws_instance'])[0].values.monitoring: Invalid value: false: Expected value: true
    Done
    ```

---