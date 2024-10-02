# Check EC2 Auto Scaling Groups

Launch Templates is a capability that enables to templatize your launch requests. Launch Templates can help simplify and streamline the launch process for Auto Scaling. Launch Templates reduce the number of steps required to create an instance by capturing all launch parameters within one resource. This makes the process easy to reproduce. Launch Templates make it easier to implement standards and best practices, helping you to better manage costs, improve your security posture, and minimize the risk of deployment errors.

A launch template is similar to a launch configuration, in that it specifies instance configuration information. It includes the ID of the Amazon Machine Image (AMI), the instance type, a key pair, security groups, and other parameters used to launch EC2 instances. However, defining a launch template instead of a launch configuration allows you to have multiple versions of a launch template.

It is recommended that you use migrate to launch templates to ensure that you're accessing the latest features and improvements. Not all Amazon EC2 Auto Scaling features are available when you use launch configurations. 

You can read more about it from the following links:
[Auto Scaling launch templates](https://docs.aws.amazon.com/autoscaling/ec2/userguide/launch-templates.html)
[Auto Scaling launch configurations](https://docs.aws.amazon.com/autoscaling/ec2/userguide/launch-configurations.html)

## Policy Details:

- **Policy Name:** check-ec2-auto-scaling-groups
- **Check Description:** This policy ensures that EC2 Auto Scaling Groups use launch templates instead of launch configurations
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
    kyverno-json scan --payload test/good-test/good-payload-01.json --policy check-ec2-auto-scaling-groups.yaml 
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - check-ec2-auto-scaling-groups / check-ec2-auto-scaling-groups /  PASSED
    Done
    ```

    b. **Test Against Invalid Payload:**
    ```
    kyverno-json scan --payload test/bad-test/bad-payload-01.json --policy check-ec2-auto-scaling-groups.yaml 
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - check-ec2-auto-scaling-groups / check-ec2-auto-scaling-groups /  FAILED
    -> Auto Scaling Groups should use EC2 launch templates instead of launch configurations
    -> all[0].check.~.(planned_values.root_module.resources[?type=='aws_autoscaling_group'])[0].values.(!launch_template): Invalid value: true: Expected value: false
    Done
    ```

---