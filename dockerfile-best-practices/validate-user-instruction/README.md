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
    nctl transform -r test/bad-test/Dockerfile -o test/bad-test/bad-payload.json
    ```

2. **Test the Policy with Kyverno:**
    ```bash
    kyverno apply validate-user-instruction.yaml --json test/bad-test/bad-payload.json
    ```
    
    a. **Test Policy Against Valid Payload:**
    ```bash
    kyverno apply validate-user-instruction.yaml --json test/good-test/good-payload.json
    ```

    This produces the output:
    ```
    mastersans@mastersans validate-user-instruction % kyverno apply validate-user-instruction.yaml --json test/good-test/good-payload.json

    Applying 1 policy rule(s) to 1 resource(s)...

    pass: 1, fail: 0, warn: 0, error: 0, skip: 0
    ```

    b. **Test Policy Against Invalid Payload:**
    ```bash
    kyverno apply validate-user-instruction.yaml --json test/bad-test/bad-payload.json
    ```

    This produces the output:
    ```
    mastersans@mastersans validate-user-instruction % kyverno apply validate-user-instruction.yaml --json test/bad-test/bad-payload.json

    Applying 1 policy rule(s) to 1 resource(s)...
    policy validate-user-instruction -> resource JSON payload failed:
    1 -  USER instruction is not present in the Dockerfile


    pass: 0, fail: 1, warn: 0, error: 0, skip: 0
    ```

---

By adhering to this policy, you enhance the security posture of your Dockerized applications by ensuring that they run with appropriate user privileges, thus minimizing the potential impact of security threats and following the least privilege model.