# Check Dead Letter Queue Config

Dead Letter Queues (DLQs) allow Lambda functions to be set up with an SQS queue or SNS topic to capture information about failed asynchronous requests. When a Lambda function's processing fails and the request has exhausted its retries, the Lambda service can store details of the failed request to the configured DLQ. These failed messages can then be examined to determine the cause of failures.

## Policy Details:

- **Policy Name:** check-dead-letter-queue-config
- **Check Description:** This policy ensures that AWS Lambda function is configured for a Dead Letter Queue(DLQ)
- **Policy Category:** AWS Lambda Best Practices

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
    kyverno-json scan --payload test/good-test/good-payload-01.json --policy check-dead-letter-queue-config.yaml --bindings test/binding.yaml
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading bindings ...
    - analyzer -> map[resource:map[type:terraform-plan]]
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - PASSED (POLICY=check-dead-letter-queue-config, RULE=check-dead-letter-queue-config)
    Done
    ```

    b. **Test Against Invalid Payload:**
    ```
    kyverno-json scan --payload test/bad-test/bad-payload-01.json --policy check-dead-letter-queue-config.yaml --bindings test/binding.yaml
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading bindings ...
    - analyzer -> map[resource:map[type:terraform-plan]]
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - FAILED (POLICY=check-dead-letter-queue-config, RULE=check-dead-letter-queue-config)
    -> AWS Lambda function should be configured for a Dead Letter Queue(DLQ) (CHECK=spec.rules[0].assert.all[0])
    -> Invalid value: false: Expected value: true (PATH=~.(planned_values.root_module.resources[?type=='aws_lambda_function'])[0].values.(dead_letter_config != `[]`))
    Done
    ```

---