# Check EC2 Transit Gateways VPC Request

A Transit Gateway serves as a central network hub, connecting multiple VPCs and on-premises networks. When configured to automatically accept VPC attachment requests, there is a risk of unauthorized or unintended networks gaining access, potentially compromising security and leading to data breaches. 

"Auto Accept Shared Attachments" feature can pose a security risk by automatically accepting cross-account attachments. Disabling this feature is a recommended best practice to maintain control over which accounts are allowed to connect, ensuring only trusted and authorized requests are approved. 

## Policy Details:

- **Policy Name:** check-transit-gateways-vpc-request
- **Check Description:** This policy ensures that an EC2 Transit Gateway does not automatically accept VPC attachment requests
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
    kyverno-json scan --payload test/good-test/good-payload-01.json --policy check-transit-gateways-vpc-request.yaml 
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - check-transit-gateways-vpc-request / check-transit-gateways-vpc-request /  PASSED
    Done
    ```

    b. **Test Against Invalid Payload:**
    ```
    kyverno-json scan --payload test/bad-test/bad-payload-01.json --policy check-transit-gateways-vpc-request.yaml 
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - check-transit-gateways-vpc-request / check-transit-gateways-vpc-request /  FAILED
    -> 'auto_accept_shared_attachments' should either be omitted or set to 'disable'
    -> all[0].check.~.(planned_values.root_module.resources[?type=='aws_ec2_transit_gateway'])[0].values.(auto_accept_shared_attachments != 'enable'): Invalid value: false: Expected value: true
    Done
    ```

---