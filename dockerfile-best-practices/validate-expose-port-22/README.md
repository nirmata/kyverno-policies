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
- Ensure you have `kyverno-json` installed on your machine.
- Ensure you have [nctl `v3.4.0`](https://downloads.nirmata.io/nctl/downloads/) or a higher version installed.

1. **Extract JSON equivalent of the Dockerfile:**
    ```bash
    nctl scan dockerfile -r test/good-test/Dockerfile --show-json > payload.json
    ```

2. **Test the Policy with Kyverno:**
    ```bash
    kyverno-json scan --payload payload.json --policy validate-expose-port-22.yaml
    ```
    
    a. **Test Policy Against Valid Payload:**
    ```bash
    kyverno-json scan --policy validate-expose-port-22.yaml --payload test/good-test/good-payload.json
    ```

    This produces the output:
    ```
    
    ```

    b. **Test Against Invalid Payload:**
    ```bash
    kyverno-json scan --policy validate-expose-port-22.yaml --payload test/bad-test/bad-payload.json
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - validate-expose-port-22 / validate-expose-port-22 /  FAILED: Exposing port 22 in Dockerfile: any[0].check.(Stages[].ExposedPorts | contains("22/tcp")): Invalid value: false: Expected value: true
    Done
    ```

---

By adhering to this policy, you bolster the security of your Dockerized applications by minimizing the exposure of port 22, thereby reducing the risk of unauthorized access.