# Validating Exposed Port 22 in Dockerfile

Exposing port 22 in a Dockerfile can pose security risks by potentially allowing unauthorized access to the containerized system. This policy aims to validate whether port 22 is exposed in Dockerfiles to enhance security practices.

## Policy Details:

- **Policy Name:** validate-expose-port-22
- **Check Description:** This policy checks whether Dockerfiles exposes port 22.
- **Policy Category:** Dockerfile Security Best Practices

## How It Works:

### Validation Criteria:_____

**Key** : Ports

- **Condition:** If `Ports` under EXPOSE has 22 or 22/tcp
  - **Result:** FAIL
  - **Reason:** Exposing port 22 could lead to security vulnerabilities, as it is commonly associated with SSH and remote access.

- **Condition:** If `Port` doesn't exposes 22 or 22/tcp
  - **Result:** PASS
  - **Reason:** Compliance with the policy is achieved when port 22 is not exposed, aligning with best security practices to mitigate potential risks.

### Policy Validation Testing Instructions

To evaluate and test the policy ensuring Dockerfile compliance:

For testing this policy, follow these steps:
- Ensure you have `kyverno` installed on your machine.
- Ensure you have [nctl `v4.3.0`](https://downloads.nirmata.io/nctl/downloads/) or a higher version installed.

1. **Extract JSON equivalent of the Dockerfile:**
    ```bash
    nctl transform -r test/bad-test/Dockerfile -o test/bad-test/bad-payload.json
    ```

2. **Test the Policy with Kyverno:**
    ```bash
    kyverno apply validate-expose-port-22.yaml --json test/bad-test/bad-payload.json
    ```
    
    a. **Test Policy Against Valid Payload:**
    ```bash
    kyverno apply validate-expose-port-22.yaml --json test/good-test/good-payload.json
    ```

    This produces the output:
    ```
    mastersans@mastersans validate-expose-port-22 % kyverno apply validate-expose-port-22.yaml --json test/good-test/good-payload.json

    Applying 1 policy rule(s) to 1 resource(s)...

    pass: 1, fail: 0, warn: 0, error: 0, skip: 0
    ```

    b. **Test Policy Against Invalid Payload:**
    ```bash
    kyverno apply validate-expose-port-22.yaml --json test/bad-test/bad-payload.json
    ```

    This produces the output:
    ```
    mastersans@mastersans validate-expose-port-22 % kyverno apply validate-expose-port-22.yaml --json test/bad-test/bad-payload.json

    Applying 1 policy rule(s) to 1 resource(s)...
    policy validate-expose-port-22 -> resource JSON payload failed:
    1 -  Port 22 should not be exposed


    pass: 0, fail: 1, warn: 0, error: 0, skip: 0
    ```

---

By adhering to this policy, you bolster the security of your Dockerized applications by minimizing the exposure of port 22, thereby reducing the risk of unauthorized access.