# Check Last User

The last USER instruction in the Dockerfile is what determines the default user for the container when it starts. This policy validates that the last USER is not root. Running containers as non-root users significantly limits the potential damage that attackers can inflict if they manage to compromise a container.

## Policy Details:

- **Policy Name:** check-last-user
- **Check Description:** This policy checks whether the last USER is not root in the Dockerfile.
- **Policy Category:** Dockerfile Best Practices for Security

## How It Works:

### Validation Criteria:

**Key**: USER

- **Condition:** If last `USER` instruction is set to root
  - **Result:** FAIL

- **Condition:** If last `USER` instruction is not root
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
    kyverno apply check-last-user.yaml --json test/bad-test/bad-payload.json
    ```
    
    a. **Test Policy Against Valid Payload:**
    ```bash
    kyverno apply check-last-user.yaml --json test/good-test/good-payload.json
    ```

    This produces the output:
    ```
    mastersans@p@mastersans check-last-user % kyverno apply check-last-user.yaml --json test/good-test/good-payload.json

    Applying 1 policy rule(s) to 1 resource(s)...

    pass: 1, fail: 0, warn: 0, error: 0, skip: 0 
    ```

    b. **Test Policy Against Invalid Payload:**
    ```bash
    kyverno apply check-last-user.yaml --json test/bad-test/bad-payload.json
    ```

    This produces the output:
    ```
    mastersans@mastersans check-last-user % kyverno apply check-last-user.yaml --json test/bad-test/bad-payload.json

    Applying 1 policy rule(s) to 1 resource(s)...
    policy check-last-user -> resource JSON payload failed:
    1 -  Default user for the container should not be root


    pass: 0, fail: 1, warn: 0, error: 0, skip: 0 
    ```

---

Adhering to this policy strengthens overall Docker container security.
