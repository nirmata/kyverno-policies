# Check EC2 Public IP

Public IP addresses can make EC2 instances directly accessible from the internet, which might not always be desirable from a security or compliance standpoint. In many cases, you might not want your EC2 instances to have public IP addresses unless they need to be publicly accessible. Having a public IP address can expose your EC2 instance to potential security risks, such as unauthorized access or attacks.

## Policy Details:

- **Policy Name:** check-ec2-public-ip
- **Check Description:** This policy ensures that the EC2 instance is not assigned a public IP address
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
    kyverno-json scan --payload test/good-test/good-payload-01.json --policy check-ec2-public-ip.yaml --bindings test/binding.yaml
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading bindings ...
    - analyzer -> map[resource:map[type:terraform-plan]]
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - check-ec2-public-ip / check-ec2-public-ip /  PASSED
    Done
    ```

    b. **Test Against Invalid Payload:**
    ```
    kyverno-json scan --payload test/bad-test/bad-payload-01.json --policy check-ec2-public-ip.yaml --bindings test/binding.yaml
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading bindings ...
    - analyzer -> map[resource:map[type:terraform-plan]]
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - check-ec2-public-ip / check-ec2-public-ip /  FAILED
    -> EC2 instance should not be created or launched with a public IP address to avoid exposing it to the internet
    -> all[0].check.~.(planned_values.root_module.resources[?type=='aws_instance' || type=='aws_launch_configuration'])[0].values.associate_public_ip_address: Invalid value: true: Expected value: false
    Done
    ```

---