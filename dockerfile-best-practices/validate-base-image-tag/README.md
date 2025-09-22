# Validating Base Image Tag in Dockerfile

Ensuring the use of version tags and digests instead of the latest image tag in a Dockerfile is crucial for maintaining control, reproducibility, and stability in containerized environments. This policy aims to validate whether the base image tag is appropriately defined to promote reliable container deployment practices.

## Policy Details:

- **Policy Name:** validate-base-image-tag
- **Check Description:** This policy checks whether the base image tag is defined with a specific version or digest in the Dockerfile.
- **Policy Category:** Dockerfile Best Practices for Stability and Reproducibility

## How It Works:

### Validation Criteria:

**Key**: Image

- **Condition:** If the base image tag is set to `latest` or doesn't have `:`
  - **Result:** FAIL

- **Condition:** If the base image tag is set to a specific version or digest with a `:` or `scratch` or `base`
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
    kyverno apply validate-base-image-tag.yaml --json test/bad-test/bad-payload.json
    ```
    
    a. **Test Policy Against Valid Payload:**
    ```bash
    kyverno apply validate-base-image-tag.yaml --json test/good-test/good-payload.json
    ```

    This produces the output:
    ```
    mastersans@mastersans validate-base-image-tag % kyverno apply validate-base-image-tag.yaml --json test/good-test/good-payload.json

    Applying 1 policy rule(s) to 1 resource(s)...

    pass: 1, fail: 0, warn: 0, error: 0, skip: 0
    ```

    b. **Test Policy Against Invalid Payload:**
    ```bash
    kyverno apply validate-base-image-tag.yaml --json test/bad-test/bad-payload.json
    ```

    This produces the output:
    ```
    mastersans@mastersans validate-base-image-tag % kyverno apply validate-base-image-tag.yaml --json test/bad-test/bad-payload.json

    Applying 1 policy rule(s) to 1 resource(s)...
    policy validate-base-image-tag -> resource JSON payload failed:
    1 -  Base Image is missing version tags/digests


    pass: 0, fail: 1, warn: 0, error: 0, skip: 0
    ```

---

By adhering to this policy, you promote stability and reproducibility in your Dockerized applications, mitigating the risk of unexpected changes and ensuring consistent behavior across deployments.