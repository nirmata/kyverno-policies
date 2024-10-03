# Check EC2 IMDSv1

The Instance Metadata Service (IMDS) is a feature provided by AWS that allows applications running on an EC2 instance to get information about the instance. This service is attached locally to every EC2 instance, the IMDS runs on a special “link local” IP address of 169.254.169.254 that means only software running on the instance can access it. For applications with access to IMDS, it makes available metadata about the instance, its network,  storage and other information. The IMDS also makes the AWS credentials available for any IAM role that is attached to the instance.

You can access instance metadata from a running instance using one of the following methods:

- Instance Metadata Service Version 1 (IMDSv1) – a request/response method
- Instance Metadata Service Version 2 (IMDSv2) – a session-oriented method

IMDSv2 adds an authentication step, making it harder for unauthorized users or attackers to access instance metadata. This feature helps protect against various vulnerabilities, such as misconfigured firewalls and SSRF attacks, making your EC2 instances more secure.

You can read more about it from the following links:
[Add defense in depth against open firewalls, reverse proxies, and SSRF vulnerabilities with enhancements to the EC2 Instance Metadata Service](https://aws.amazon.com/blogs/security/defense-in-depth-open-firewalls-reverse-proxies-ssrf-vulnerabilities-ec2-instance-metadata-service/)
[Use IMDSv2](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/configuring-instance-metadata-service.html)

## Policy Details:

- **Policy Name:** check-imds-v1
- **Check Description:** This policy ensures that EC2 instances make use of IMDSv2 instead of IMDSv1
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
    kyverno-json scan --payload test/good-test/good-payload-01.json --policy check-imds-v1.yaml --bindings test/binding.yaml 
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading bindings ...
    - analyzer -> map[resource:map[type:terraform-plan]]
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - PASSED (POLICY=check-imds-v1, RULE=check-imds-v1)
    Done
    ```

    b. **Test Against Invalid Payload:**
    ```
    kyverno-json scan --payload test/bad-test/bad-payload-01.json --policy check-imds-v1.yaml --bindings test/binding.yaml 
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading bindings ...
    - analyzer -> map[resource:map[type:terraform-plan]]
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - FAILED (POLICY=check-imds-v1, RULE=check-imds-v1)
    -> IMDSv1 should not be enabled, use IMDSv2 instead (CHECK=spec.rules[0].assert.all[0])
    -> Invalid value: false: Expected value: true (PATH=~.(planned_values.root_module.resources[?type=='aws_instance' || type=='aws_launch_template' || type=='aws_launch_configuration'])[0].values.~.(metadata_options || `[{}]`)[0].(http_endpoint == 'disabled' || http_tokens == 'required'))
    Done
    ```

---