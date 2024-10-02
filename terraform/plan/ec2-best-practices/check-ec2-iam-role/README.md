# Check EC2 IAM Role

An IAM role acts as an identity with specific permission policies that determine the allowed and disallowed actions within AWS. Creating IAM roles and attaching them to manage permissions for EC2 instances ensures that access is controlled and temporary credentials are used, enhancing security.

## Policy Details:

- **Policy Name:** check-ec2-iam-role
- **Check Description:** This policy ensures that an IAM role is attached to an EC2 instance
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
    kyverno-json scan --payload test/good-test/good-payload-01.json --policy check-ec2-iam-role.yaml --bindings test/binding.yaml 
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading bindings ...
    - analyzer -> map[resource:map[type:terraform-plan]]
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - PASSED (POLICY=check-ec2-iam-role, RULE=check-ec2-iam-role)
    Done
    ```

    b. **Test Against Invalid Payload:**
    ```
    kyverno-json scan --payload test/bad-test/bad-payload-01.json --policy check-ec2-iam-role.yaml --bindings test/binding.yaml 
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading bindings ...
    - analyzer -> map[resource:map[type:terraform-plan]]
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - FAILED (POLICY=check-ec2-iam-role, RULE=check-ec2-iam-role)
    -> 'iam_instance_profile' must be present for the EC2 instance (CHECK=spec.rules[0].assert.all[0])
    -> Invalid value: true: Expected value: false (PATH=~.(planned_values.root_module.resources[?type=='aws_instance'])[0].values.(!iam_instance_profile))
    Done
    ```

---