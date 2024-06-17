# Validating USER Instruction in Dockerfile

Ensuring the presence and proper configuration of the USER instruction in a Dockerfile is essential for enhancing the security posture of containerized applications. This policy aims to validate whether the USER instruction is appropriately defined to promote secure container execution practices.

## Policy Details:

- **Policy Name:** validate-user-instruction
- **Check Description:** This policy checks whether the USER instruction is defined in the Dockerfile.
- **Policy Category:** Dockerfile Best Practices for Security

## How It Works:

### Validation Criteria:

**Key**: USER

- **Condition:** If `USER` instruction is not defined
  - **Result:** FAIL

- **Condition:** If `USER` instruction is defined
  - **Result:** PASS

### Policy Validation Testing Instructions

To evaluate and test the policy ensuring Dockerfile compliance:

Follow these steps:

1. **Extract JSON equivalent of the Dockerfile:**
    ```bash
    nctl scan dockerfile -r test/good-test/Dockerfile --show-json > payload.json
    ```

2. **Test the Policy with Kyverno:**
    ```bash
    kyverno-json scan --payload payload.json --policy validate-user-instruction.yaml
    ```
    
    a. **Test Policy Against Valid Payload:**
    ```bash
    kyverno-json scan --policy validate-user-instruction.yaml --payload test/good-test/good-payload.json
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - validate-user-instruction / validate-user-instruction /  PASSED
    Done
    ```

    b. **Test Against Invalid Payload:**
    ```bash
    kyverno-json scan --policy validate-user-instruction.yaml --payload test/bad-test/bad-payload.json
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - validate-user-instruction / validate-user-instruction /  FAILED: USER instruction is not present in the Dockerfile: any[0].check.(Stages[].Commands[?Name=='USER'][] | length(@) > `0`): Invalid value: false: Expected value: true
    Done
    ```

---

By adhering to this policy, you enhance the security posture of your Dockerized applications by ensuring that they run with appropriate user privileges, thus minimizing the potential impact of security threats and following the least privilege model.