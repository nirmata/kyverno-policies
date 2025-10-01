# Validating Healthcheck Instruction in Dockerfile

Ensuring the presence and proper configuration of the HEALTHCHECK instruction in a Dockerfile is crucial for maintaining the health and stability of containerized applications. This policy aims to validate whether the HEALTHCHECK instruction is appropriately defined to promote robust container orchestration and monitoring practices.

## Policy Details:

- **Policy Name:** validate-healthcheck-instruction
- **Check Description:** This policy checks whether the HEALTHCHECK instruction is defined in the Dockerfile.
- **Policy Category:** Dockerfile Best Practices for Container Orchestration

## How It Works:

### Validation Criteria:

**Key**: HEALTHCHECK

- **Condition:** If `HEALTHCHECK` instruction is not defined
  - **Result:** FAIL
  - **Reason:** The absence of a HEALTHCHECK instruction can impede container orchestration tools' ability to determine the health status of the container, potentially leading to incorrect decisions regarding container lifecycle management.

- **Condition:** If `HEALTHCHECK` instruction is defined
  - **Result:** PASS
  - **Reason:** Compliance with the policy is achieved when the HEALTHCHECK instruction is appropriately configured, enabling container orchestration tools to monitor the container's health status effectively.

### Policy Validation Testing Instructions

To evaluate and test the policy ensuring Dockerfile compliance:

Follow these steps:

1. **Extract JSON equivalent of the Dockerfile:**
    ```bash
    nctl transform -r test/bad-test/Dockerfile -o test/bad-test/bad-payload.json
    ```

2. **Test the Policy with Kyverno:**
    ```bash
    kyverno apply validate-healthcheck-instruction.yaml --json test/bad-test/bad-payload.json
    ```
    
    a. **Test Policy Against Valid Payload:**
    ```bash
    kyverno apply validate-healthcheck-instruction.yaml --json test/good-test/good-payload.json
    ```

    This produces the output:
    ```
    mastersans@mastersans validate-healthcheck-instruction % kyverno apply validate-healthcheck-instruction.yaml --json test/good-test/good-payload.json

    Applying 1 policy rule(s) to 1 resource(s)...

    pass: 1, fail: 0, warn: 0, error: 0, skip: 0
    ```

    b. **Test Policy Against Invalid Payload:**
    ```bash
    kyverno apply validate-healthcheck-instruction.yaml --json test/bad-test/bad-payload.json
    ```

    This produces the output:
    ```
    mastersans@mastersans validate-healthcheck-instruction % kyverno apply validate-healthcheck-instruction.yaml --json test/bad-test/bad-payload.json

    Applying 1 policy rule(s) to 1 resource(s)...
    policy validate-healthcheck-instruction -> resource JSON payload failed:
    1 -  HEALTHCHECK instruction is not defined


    pass: 0, fail: 1, warn: 0, error: 0, skip: 0
    ```

---

By adhering to this policy, you enhance the reliability and manageability of your Dockerized applications by ensuring that appropriate health checks are defined, enabling efficient container monitoring and orchestration.